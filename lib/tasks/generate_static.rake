#encoding: utf-8
require "erb"
require "tilt"
require "tilt/haml"

desc "generate static template for less resource useage"
namespace :gs do

  def run_operation(info, &block)
    _t = Time.now
    success = yield block
    tlast = ((Time.now - _t).to_f*1000).to_i

    if success == false
      printf("%-10s - %-20s [%sms]\n", "[Failed]", info, tlast)
    else
      printf("%-10s - %-20s [%sms]\n", "[done]", info, tlast)
    end
  end

  def generate_html(output, target_file)
    File.open(target_file, "wb+") { |file| file.puts output }
  end


  desc "generate static html,in order to reduce pressure on server"
  task :home_page => :environment do
    root_path = ENV["APP_ROOT_PATH"]
    $:.unshift(root_path)
    # scope - for binding
    require "config/boot.rb"
    include ApplicationHelper
    include HomeHelper
    include TeasHelper
    include Sinatra::FormHelpers
    # extract template from sinatra
    require "lib/utils/tilt.rb"
    include Utils::ClassMethods

    home_path = [root_path, "app/views/home"].join("/")
    @teas = Tea.all(:onsale => true)

    set :root_path, root_path
    set :views, "app/views/admin"
    set :layout, :"../layouts/layout"
    run_operation "购物车(web版)" do
      generate_html(haml(:template_cart), join_path(home_path, "cart.erb"))
    end

    run_operation "购物车(移动端)" do
      generate_html(haml(:template_mobile_cart), join_path(home_path, "mobile_cart.erb"))
    end

    set :layout, :"../layouts/layout.v2"
    run_operation "首页" do
      generate_html(erb(:template_home), join_path(home_path,"home.erb"))
    end
  end
end
