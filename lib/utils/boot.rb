#encoding: utf-8
module Utils
  module Boot
    def recursion_require(dir_path, regexp, base_path = ENV["APP_ROOT_PATH"], sort_rules = [])
      _temp_files, _temp_dirs = [], []
      Dir.entries("%s/%s" % [base_path, dir_path]).sort.each do |dir_name|
        next if %w[. ..].include?(dir_name)

        path_name = "%s/%s/%s" % [base_path, dir_path, dir_name]
        if File.file?(path_name) and dir_name =~ /\.rb$/
          dir_name.scan(regexp).empty? ? (warn "warning not match #{regexp.inspect} - #{dir_name}") : _temp_files.push(path_name)
        elsif File.directory?(path_name)
          _temp_dirs.push(dir_name)
        end
      end

      if not sort_rules.empty?
        _temp_files = sort_by_rules(_temp_files, sort_rules) 
      end
      _temp_files.each do |file|
        require file
      end if not _temp_files.empty?

      _temp_dirs.each do |dir_name|
        recursion_require("%s/%s" % [dir_path, dir_name], regexp, base_path, sort_rules)
      end if not _temp_dirs.empty?
    end

    def sort_by_rules(array, rules)
      _array = rules.inject([]) do |tmp, rule|
        tmp.push(array.grep(rule))
      end.flatten!
      _array.push(array - _array).flatten!
    end
  end
end
