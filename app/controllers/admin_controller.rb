#encoding: utf-8 
require "erb"
class AdminController < ApplicationController
  enable :logging
  set :views, ENV["VIEW_PATH"] + "/admin"

  #无权限则登陆
  #当前controller中默认url path前缀为/admin
  #[local] get "/hello" => [global] get "/admin/hello"
  #[global] get "/admin/hello" => [local] request.path_info == "/hello"
  before do 
    pass if %w(/login /chk_login /template).include?(request.path_info)
    authenticate!
  end

  # GET /admin
  get "/" do
    @transactions = Transaction.all

    haml :transactions, layout: :"../layouts/layout"
  end

  get "/members" do
    @members = Member.all

    haml :members, layout: :"../layouts/layout"
  end

  get "/blogs" do
    post_path = File.join(Settings.octopress.path,"source/_posts") 
  end

  # GET /admin/login
  get "/login" do
    unless request.cookies["login_state"].to_s.strip.empty?
      redirect "/admin"
    else
      haml :login, layout: :"../layouts/layout"
    end
  end

  post "/chk_login" do
    # chk name and password
    if params[:name] == Settings.login.name and 
       params[:password] == Settings.login.password
      # 必须指定path，否则cookie只在此path下有效
      # authencate! 在application_controller下，即"/"
      response.set_cookie "login_state", {:value=> remote_ip, :path => "/", :max_age => "2592000"}

      redirect request.cookies["before_login_path"] || "/admin"
    else
      response.set_cookie "login_state", {:value=> "", :path => "/", :max_age => "2592000"}

      flash[:warning] = "登陆失败，请重新输入."
      redirect "/admin/login"
    end
  end

  # execute linux shell command
  # return array with command result
  # [execute status, execute result] 
  def run_command(cmd)
    IO.popen(cmd) do |stdout|
      stdout.reject(&:empty?)
    end.unshift($?.exitstatus.zero?)
  end 


  #trigger rspec to load /admin/template
  #to generate static file
  post "/generate" do
   # cmd = "cd #{ENV['APP_ROOT_PATH']} && bundle exec rspec spec/controller/generate_static_files_spec.rb"
   # status, *result = run_command(cmd)
   # @status = "执行" + (status ? "成功" : "失败") + ":"
   # @result = result.join("<br>")

    @teas = Tea.all(:onsale => true)
    home_path = File.join(ENV["APP_ROOT_PATH"], "app/views/home")
    begin
      File.open(File.join(home_path, "home.erb"), "wb+") do |file|
        file.puts erb(:template_home, layout: :"../layouts/layout.v2")
      end
    rescue => e
      @result = "1. 首页生成失败.<br>   #{e.message}"
    else
      @result = "1. 首页生成功能."
    end
    begin
      File.open(File.join(home_path, "cart.erb"), "wb+") do |file|
        file.puts haml(:template_cart, layout: :"../layouts/layout")
      end
    rescue => e
      @result << "<br>2. 购物车生成失败.<br>   #{e.message}"
    else
      @result << "<br>2. 购物车生成成功."
    end
    begin
      File.open(File.join(home_path, "mobile_cart.erb"), "wb+") do |file|
        file.puts haml(:template_mobile_cart, layout: :"../layouts/layout")
      end
    rescue => e
      @result << "<br>3. 购物车(手机界面)生成失败.<br>   #{e.message}"
    else
      @result << "<br>3. 购物车(手机界面)生成成功."
    end

    haml :_modal, layout: false
  end

end
