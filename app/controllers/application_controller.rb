#encoding: utf-8
class ApplicationController < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Flash
  # register Sinatra::Auth

  helpers ApplicationHelper
  helpers HomeHelper
  helpers TeasHelper
  helpers Sinatra::FormHelpers
  
  enable :sessions, :logging, :dump_errors, :raise_errors, :static, :method_override

  # css/js/view配置文档
  use SassHandler
  use CoffeeHandler
  use AssetHandler

  #load css/js file
  get "/js/:file" do
    file = File.join(ENV["APP_ROOT_PATH"],"app/assets/javascripts/#{params[:file]}")
    send_file(file, :disposition => :inline) if File.exist?(file)
  end
  get "/css/:file" do
    file = File.join(ENV["APP_ROOT_PATH"],"app/assets/stylesheets/#{params[:file]}")
    send_file(file, :disposition => :inline) if File.exist?(file)
  end

  #global shared function
  ##############################################
  #authen user
  def authenticate! 
    unless session[:login_state]
      # 记录登陆前的path，登陆成功后返回至此path

      flash[:notice] = "继续操作前请登录."
      redirect "/admin/login"
    end
  end

  def remote_ip
    request.env["REMOTE_ADDR"] || "n-i-l"
  end

  def remote_browser
    request.env["HTTP_USER_AGENT"] || "n-i-l"
  end
end
