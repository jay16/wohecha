require "rack"
require "tilt"

module Utils
  module Tiltor
    module ContentTyped; attr_accessor :content_type; end

    def erb(template, options = {}, locals = {}, &block)
      render(:erb, template, options, locals, &block)
    end

    def haml(template, options = {}, locals = {}, &block)
      render(:haml, template, options, locals, &block)
    end

    def slim(template, options = {}, locals = {}, &block)
      render(:slim, template, options, locals, &block)
    end

    def coffee(template, options = {}, locals = {})
      options.merge! :layout => false, :default_content_type => :js
      render :coffee, template, options, locals
    end

    def markdown(template, options = {}, locals = {})
      render :markdown, template, options, locals
    end

    def sass(template, options = {}, locals = {})
      options.merge! :layout => false, :default_content_type => :css
      render :sass, template, options, locals
    end

    def scss(template, options = {}, locals = {})
      options.merge! :layout => false, :default_content_type => :css
      render :scss, template, options, locals
    end

    def less(template, options = {}, locals = {})
      options.merge! :layout => false, :default_content_type => :css
      render :less, template, options, locals
    end

    def render(engine, data, options = {}, locals = {}, &block)
      # merge app-level options
      #engine_options  = settings.respond_to?(engine) ? settings.send(engine) : {}
      #options.merge!(engine_options) { |key, v1, v2| v1 }
      engine_options = {}

      # extract generic options
      locals          = options.delete(:locals) || locals         || {}
      views           = options.delete(:views)  || settings.views || "./views"
      layout          = options[:layout]
      layout          = false if layout.nil? && options.include?(:layout) 
      eat_errors      = layout.nil?
      layout          = engine_options[:layout] if layout.nil? or (layout == true && engine_options[:layout] != false)
      layout          = @default_layout         if layout.nil? or layout == true
      layout_options  = options.delete(:layout_options) || {}
      content_type    = options.delete(:content_type)   || options.delete(:default_content_type)
      layout_engine   = options.delete(:layout_engine)  || engine
      scope           = options.delete(:scope)          || @bindings || self
      options.delete(:layout)

      # set some defaults
      options[:outvar]           ||= '@_out_buf'
      options[:default_encoding] ||= 'utf-8'

      # compile and render template
      begin
        layout_was      = @default_layout
        @default_layout = false
        template        = compile_template(engine, data, options, views)
        output          = template.render(scope, locals, &block)
      ensure
        @default_layout = layout_was
      end

      # customer settings
      if layout.nil? and settings.respond_to?(:layout) 
        layout = settings.layout
      end
      # render layout
      if layout
        options = options.merge(:views => views, :layout => false, :eat_errors => eat_errors, :scope => scope).
                merge!(layout_options)
        catch(:layout_missing) { return render(layout_engine, layout, options, locals) { output } }
      end

      output.extend(ContentTyped).content_type = content_type if content_type
      output
    end

    def join_path(base, path)
      if File.exist?(path.to_s)
        #warn "WARING: #{path} - exist without base - #{base}"
        path
      else
        "%s/%s" % [base, path]
      end
    end

    # Calls the given block for every possible template file in views,
    # named name.ext, where ext is registered on engine.
    def find_template(views, name, engine)
      views = join_path(settings.root_path, views) if settings.respond_to?(:root_path)
      yield ::File.join(views, "#{name}.#{@preferred_extension}")
      Tilt.mappings.each do |ext, engines|
        next unless ext != @preferred_extension and engines.include? engine
        yield ::File.join(views, "#{name}.#{ext}")
      end
    end

    def compile_template(engine, data, options, views)
      eat_errors = options.delete :eat_errors
      template = Tilt[engine]
      raise "Template engine not found: #{engine}" if template.nil?

      case data
      when Symbol
        path = nil
        found = false
        @preferred_extension = engine.to_s
        find_template(views, data, template) do |file|
          path ||= file # keep the initial path rather than the last one
          if found = File.exist?(file)
            path = file
            break
          end
        end
        throw :layout_missing if eat_errors and not found
        template.new(path, 1, options)
      when Proc, String
        body = data.is_a?(String) ? Proc.new { data } : data
        path, line = settings.caller_locations.first
        template.new(path, line.to_i, options, &body)
      else
        raise ArgumentError, "Sorry, don't know how to render #{data.inspect}."
      end
    end

    # Sets an option to the given value.  If the value is a proc,
    # the proc will be called every time the option is accessed.
    def set(option, value = (not_set = true), ignore_setter = false, &block)
      raise ArgumentError if block and !not_set
      value, not_set = block, false if block

      if not_set
        raise ArgumentError unless option.respond_to?(:each)
        option.each { |k,v| set(k, v) }
        return self
      end

      if respond_to?("#{option}=") and not ignore_setter
        return __send__("#{option}=", value)
      end

      setter = proc { |val| set option, val, true }
      getter = proc { value }

      case value
      when Proc
        getter = value
      when Symbol, Fixnum, FalseClass, TrueClass, NilClass
        getter = value.inspect
      when Hash
        setter = proc do |val|
          val = value.merge val if Hash === val
          set option, val, true
        end
      end

      define_singleton("#{option}=", setter) if setter
      define_singleton(option, getter) if getter
      define_singleton("#{option}?", "!!#{option}") unless respond_to? "#{option}?"
      self
    end
    # Dynamically defines a method on settings.
    def define_singleton(name, content = Proc.new)
      # replace with call to singleton_class once we're 1.9 only
      (class << self; self; end).class_eval do
        self.undef_method(name) if respond_to? name
        String === content ? class_eval("def #{name}() #{content}; end") : define_method(name, &content)
      end
    end
  end
end

