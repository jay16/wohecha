#encoding: utf-8
module Utils
  module Boot
    def recursion_require(dir_path, regexp, base_path = ENV["APP_ROOT_PATH"], sort_rules = [])
     _partition = Dir.entries("%s/%s" % [base_path, dir_path])
       .reject { |dir_name| %w[. ..].include?(dir_name) }
       .partition { |dir_name| File.file?("%s/%s/%s" % [base_path, dir_path, dir_name]) }
      _temp_files, _temp_dirs = *_partition

      if not sort_rules.empty?
        _temp_files = sort_by_rules(_temp_files, sort_rules) 
      end
      _temp_files.each do |file|
        file_path = "%s/%s/%s" % [base_path, dir_path, file]
        warn_info =  "warning not match %s - %s" % [regexp.inspect, file_path]
        file.scan(regexp).empty? ? (warn warn_info) : (require file_path)
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
