#encoding: utf-8
module Cpanel; end
class Cpanel::ApplicationController < ApplicationController
  def authenticate! 
    if request.cookies["_login_state"].to_s.strip.empty?
      # 记录登陆前的path，登陆成功后返回至此path
      response.set_cookie "_before_login_path", {:value=> request.url, :path => "/", :max_age => "2592000"}

      flash[:notice] = "继续操作前请登录."
      redirect "/cpanel/login", 302
    end
  end
end
