#encoding: utf-8 
require "net/http"
require "uri"
class HomeController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/home"

  # root
  get "/" do
    haml :index
  end

  # home page only show onsale product
  get "/home" do
    @teas = Tea.all(:onsale => true)

    erb :home, layout: :"../layouts/layout.v2"
  end

  # shop cart
  get "/cart" do
    @teas = Tea.all(:onsale => true)
    #@teas.each { |tea| tea.update(:price => tea.id * 0.01) }

    haml :cart, layout: :"../layouts/layout"
  end

  # member#subscribe
  post "/subscribe" do
    @member = Member.first_or_create(:email => params[:email]) 

    #记录最后一次订阅的ip与browser
    member = { :updated_at => DateTime.now, :ip => remote_ip, :browser => remote_browser }
    member.merge!({ :created_at => DateTime.now }) unless @member.created_at
    @member.update(member)

    #send email when subscribe successfully
    uri = URI.parse("http://main.intfocus.com/open/sendmailds")
    query = { :id => 381, :emails => params[:email] }
    uri.query = URI.encode_www_form(query)
    res = Net::HTTP.get(uri) 

    erb :subscribe, layout: :"../layouts/layout.v2"
  end


  not_found do
    "sorry"
  end
end
