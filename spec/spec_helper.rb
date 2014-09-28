ENV["RACK_ENV"] = "test"
#require 'capybara/dsl'
#require "capybara/rspec"
require "factory_girl"
require "rack/test"
require File.expand_path '../../config/boot.rb', __FILE__
require File.expand_path '../factories/transaction_factory.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  #include Capybara::DSL

  def app() 
    `cd #{ENV["APP_ROOT_PATH"]}/db && rm wohecha_test.db && cp wohecha_development.db wohecha_test.db`

    rackup  = File.read(File.dirname(__FILE__) + '/../config.ru')
    builder = "Rack::Builder.new {( %s\n )}" % rackup
    eval builder
  end

  #Capybara.app = ApplicationController 
  #Capybara.register_driver :selenium do |app|
  #  #profile = Selenium::WebDriver::Chrome::Profile.new
  #  #profile['extensions.password_manager_enabled'] = false
  #  Capybara::Selenium::Driver.new(app, :browser => :chrome)
  #end
  #Capybara.javascript_driver = :chrome
end

RSpec.configure do |config|
  config.include RSpecMixin 
  #config.include Capybara::DSL
end


def example_url
  "http://example.org"
end

def redirect_url path
  "%s%s" % [example_url, path]
end

def remote_ip
  last_request.env["REMOTE_ADDR"] || "n-i-l"
end

def remote_path
  request.env["REQUEST_PATH"] || "/"
end

def remote_browser
  last_request.env["HTTP_USER_AGENT"] || "n-i-l"
end
