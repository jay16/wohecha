#encoding: utf-8 
class AdminController < ApplicationController
  enable :logging
  set :views, ENV["VIEW_PATH"] + "/admin"

  #无权限则登陆
  #当前controller中默认url path前缀为/admin
  #[local] get "/hello" => [global] get "/admin/hello"
  #[global] get "/admin/hello" => [local] request.path_info == "/hello"
  before do 
    pass if %w(/login /chk_login /home /cart).include?(request.path_info)
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

  #generate static page to /views/home
  #current function: /home /cart
  get "/template" do
    @teas = Tea.all(:onsale => true)

    if params[:template] == "home"
      erb :template_home, layout: :"../layouts/layout.v2"
    else
      haml (params[:mobile] ? :template_mobile_cart : :template_cart), layout: :"../layouts/layout"
    end
  end

end
