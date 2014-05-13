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
  # render static files without layout 
  # already render layout when generate static file 
  get "/home" do
    @teas = Tea.all(:onsale => true)

    erb :home#, layout: :"../layouts/layout.v2"
  end

  # shop cart
  # render static files without layout 
  # already render layout when generate static file 
  get "/cart" do
    erb (mobile? ? :mobile_cart : :cart)#, layout: :"../layouts/layout"
  end

  # member#subscribe
  # redirect to /home if params[:email] is empty
  # create member when email not exist in db
  # update member when exist
  # send subscribe email when post successfully no matter email exist
  post "/subscribe" do
    if params[:email]
      @member = Member.first_or_create(:email => params[:email]) 

      #记录最后一次订阅的ip与browser
      member = { :updated_at => DateTime.now, :ip => remote_ip, :browser => remote_browser }
      member.merge!({ :created_at => DateTime.now }) unless @member.created_at
      @member.update(member)

      #send email when subscribe successfully
      uri = URI.parse("http://main.intfocus.com/open/sendmailds")
      query = { :id => 381, :emails => @member.email, :uid => 65 }
      uri.query = query.map{|k, v| [k, v].join("=")}.join("&")#URI.encode_www_form(query)
      res = Net::HTTP.get(uri) 

      erb :subscribe, layout: :"../layouts/layout.v2"
    else
      redirect "/home"
    end
  end


  not_found do
    "sorry"
  end
end
