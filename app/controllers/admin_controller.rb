#encoding: utf-8 
class AdminController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/admin"

  #无权限则登陆
  before do 
    pass if %w(/login /chk_login).include?(request.path_info)
    authenticate!
  end

  # GET /admin
  get "/" do
    @transactions = Transaction.all

    haml :transactions, layout: :"../layouts/layout"
  end

  # GET /admin/login
  get "/login" do
    if session[:login_state]
      redirect "/admin"
    else
      haml :login, layout: :"../layouts/layout"
    end
  end

  post "/chk_login" do
    if params[:name] == "hello" and params[:password] == "world" then
      session[:login_state] = true
      redirect "/admin"
    else
      session[:login_state] = false
      flash[:notice] = "登陆失败，请重新输入."
      redirect "/admin/login"
    end
  end
end
