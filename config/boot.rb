require "rubygems"

ENV["APP_NAME"] ||= "wohecha"
ENV["RACK_ENV"] ||= "development"

begin
  ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__) 
  require "rake"
  require "bundler"
  Bundler.setup
rescue => e
  puts e.backtrace &&  exit
end
Bundler.require(:default, ENV["RACK_ENV"])

ENV["APP_ROOT_PATH"] = File.expand_path("../../", __FILE__)
ENV["VIEW_PATH"] = File.join(ENV["APP_ROOT_PATH"], "app/views")

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
  system("chown -R nobody:nobody #{ENV['APP_ROOT_PATH']} && chmod -R 777 #{ENV['APP_ROOT_PATH']}")
else
  warn "#{result[0].strip} can't execute chown/chmod"
end

# 扩充require路径数组
# require 文件时会在$:数组中查找是否存在
$:.unshift(File.join(ENV["APP_ROOT_PATH"],"config"))
$:.unshift(File.join(ENV["APP_ROOT_PATH"],"lib/tasks"))
%w(controllers helpers models).each do |path|
  $:.unshift(File.join(ENV["APP_ROOT_PATH"],"app",path))
end


# config文夹下为配置信息优先加载
# modle信息已在asset-hanler中加载
# asset-hanel嵌入在application_controller
require "asset-handler"
require "form-helpers"

# application must be first
# other controller base on it
#controllers = Dir.entries(File.join(ENV["APP_ROOT_PATH"],"app/controllers"))
#  .grep(/_controller\.rb$/).map { |f| f.sub("_controller.rb","") }
#tmp_index = controllers.index("application")
#controllers[tmp_index] = controllers[0]; controllers[0] = "application"
## helper在controller中被调用，优先于controller
#controllers.each do |part| 
#  file_path = File.join(ENV["APP_ROOT_PATH"], "app/helpers", "#{part}_helper.rb")
#  `touch #{file_path}` if !File.exist?(file_path)
#  require "#{part}_helper" 
#end
require "application_helper.rb"
require "home_helper.rb"
require "transactions_helper.rb"
require "teas_helper.rb"
require "blogs_helper.rb"
require "application_controller.rb"
require "home_controller.rb"
require "transactions_controller.rb"
require "cpanel/application_controller.rb"
require "cpanel/teas_controller.rb"
require "cpanel/orders_controller.rb"
require "cpanel/home_controller.rb"
require "cpanel/blogs_controller.rb"
# controller,基类application_controller.rb
# application_controller.rb最先被引用
#controllers.each { |part| require "#{part}_controller" }
