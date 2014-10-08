require "rubygems"

root_path = File.expand_path("../../", __FILE__)
ENV["APP_NAME"] ||= "wohecha"
ENV["RACK_ENV"] ||= "development"
ENV["VIEW_PATH"] = "%s/app/views" % root_path
ENV["APP_ROOT_PATH"] = root_path

begin
  ENV["BUNDLE_GEMFILE"] ||= "%s/Gemfile" % root_path
  require "rake"
  require "bundler"
  Bundler.setup
rescue => e
  puts e.backtrace &&  exit
end
Bundler.require(:default, ENV["RACK_ENV"])

# execute linux shell command
# return array with command result
# [execute status, execute result] 
def run_command(cmd)
  IO.popen(cmd) do |stdout|
    stdout.reject(&:empty?)
  end.unshift($?.exitstatus.zero?)
end 

status, *result = run_command("whoami")
if result[0].strip == "root"
  system("chown -R nobody:nobody #{root_path} && chmod -R 777 #{root_path}")
else
  warn "warning: [#{result[0].strip}] can't execute chown/chmod"
end

# 扩充require路径数组
# require 文件时会在$:数组中查找是否存在
$:.unshift("%s/config" % root_path)
$:.unshift("%s/lib/tasks" % root_path) 
%w(controllers helpers models).each do |path|
  $:.unshift("%s/app/%s" % [root_path, path])
end

# config文夹下为配置信息优先加载
# modle信息已在asset-hanler中加载
# asset-hanel嵌入在application_controller
require "asset-handler"
require "form-helpers"

# application must be first
# other controller base on it
def recursion_require(dir_path, regexp, base_path = ENV["APP_ROOT_PATH"])
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

  _temp_files.each do |file|
    require file
  end if not _temp_files.empty?
  _temp_dirs.each do |dir_name|
    recursion_require("%s/%s" % [dir_path, dir_name], regexp, base_path)
  end if not _temp_dirs.empty?
end
recursion_require("app/helpers", /_helper\.rb$/, root_path)
recursion_require("app/controllers", /_controller\.rb$/, root_path)
