#encoding: utf-8 
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

      flash[:notice] = "登陆失败，请重新输入."
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
    cmd = "cd #{ENV['APP_ROOT_PATH']} && bundle exec rspec spec/controller/generate_static_files_spec.rb"
    status, *result = run_command(cmd)
    @status = "执行" + (status ? "成功" : "失败") + ":"
    @result = result.join("<br>")

    haml :_modal, layout: false
  end

  #generate static page to /views/home
  #current function: /home /cart
  #will be load in rspec to insert .erb files
  get "/template" do
    @teas = Tea.all(:onsale => true)

    case params[:template]
    when "home"
      erb :template_home, layout: :"../layouts/layout.v2"
    when "cart"
      haml :template_cart, layout: :"../layouts/layout"
    when "mobile_cart"
      haml :template_mobile_cart, layout: :"../layouts/layout"
    else
       "<h1> what are you doing</h1>"
    end
  end

end
