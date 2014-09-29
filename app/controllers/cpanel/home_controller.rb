#encoding: utf-8 
require "erb"
class Cpanel::HomeController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/home"

  #无权限则登陆
  #当前controller中默认url path前缀为/cpanel
  #[local]  get "/hello"        => [global] get "/cpanel/hello"
  #[global] get "/cpanel/hello" => [local] request.path_info == "/hello"
  before do 
    pass if %w[/login /template].include?(request.path_info)
    authenticate!
  end

  # GET /cpanel
  get "/" do
    @teas = Tea.all
    @transactions = Transaction.all(:order => [:created_at.desc])
    @members = Member.all(:order => [:created_at.desc]) 

    @post_path = File.join(Settings.octopress.path, "source/_posts")
    @blogs = Dir.entries(@post_path).grep(/\.markdown$/)

    haml :index, layout: :"../layouts/layout"
  end

  # get /cpanel/routes
  get "/routes" do
    rb_path = "%s/app/controllers/*.rb" % ENV["APP_ROOT_PATH"] 
    Dir.glob(rb_path).join("</br>")
  end

  ##################################
  #             login              #
  ##################################
  # GET /cpanel/login
  get "/login" do
    unless request.cookies["_login_state"].to_s.strip.empty?
      redirect "/cpanel"
    else
      @without_header = true
      haml :login, layout: :"../layouts/layout"
    end
  end

  # post /cpanel/login
  post "/login" do
    # chk name and password
    if params[:name] == Settings.login.name and 
       params[:password] == Settings.login.password
      # 必须指定path，否则cookie只在此path下有效
      # authencate! 在application_controller下，即"/"
      response.set_cookie "_login_state", {:value=> remote_ip, :path => "/", :max_age => "2592000"}

      redirect request.cookies["_before_login_path"] || "/cpanel"
    else
      response.set_cookie "_login_state", {:value=> "", :path => "/", :max_age => "2592000"}

      flash[:warning] = "登陆失败，请重新输入."
      redirect "/cpanel/login", 401
    end
  end



  # generate static file
  # post /cpanel/generate
  post "/generate" do
    @without_header = true
    @teas = Tea.all(:onsale => true)
    home_path = File.join(ENV["APP_ROOT_PATH"], "app/views/home")
    @result = []

    target = "%s/%s" % [home_path, "home.erb"]
    @result.push generate(:erb, :"home.template", target, layout: :"../../layouts/layout.v2")
    target = "%s/%s" % [home_path, "cart.erb"]
    @result.push generate(:haml, :"cart.template", target, layout: :"../../layouts/layout")
    target = "%s/%s" % [home_path, "mobile_cart.erb"]
    @result.push generate(:haml, :"mobile_cart.template", target, layout: :"../../layouts/layout")

    haml :_modal, layout: false
  end

  private

    def generate engine, template, target, options = {}
      _btime = Time.now.to_f
      begin
        output = send(engine, template, options) 
        File.open(target, "wb+") { |file| file.puts output }
      rescue => e
        result = "[失败]生成%s.<br>   %s" % [template, e.message]
      else
        result = "[成功]生成%s." % template
      end
      _tlast = ((Time.now.to_f - _btime)*1000).to_i

      "%s - [%dms]" % [result, _tlast]
    end
end
