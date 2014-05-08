#encoding: utf-8 
class HomeController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/home"

  # root
  get "/" do
    haml :index
  end

  get "/home" do
    @teas = Tea.all

    erb :home, layout: :"../layouts/layout.v2"
  end

  #购物车界面
  get "/cart" do
    @teas = Tea.all
    #@teas.each { |tea| tea.update(:price => tea.id * 0.01) }

    haml :cart, layout: :"../layouts/layout"
  end

  #订阅
  post "/subscribe" do
    @member = Member.first_or_create(:email => params[:email]) 

    #记录最后一次订阅的ip与browser
    member = { :updated_at => DateTime.now, :ip => remote_ip, :browser => remote_browser }
    member.merge!({ :created_at => DateTime.now }) unless @member.created_at

    @member.update(member)

    erb :subscribe, layout: :"../layouts/layout.v2"
  end

  not_found do
    "sorry"
  end
end
