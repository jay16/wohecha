#encoding: utf-8
#require 'sinatra/advanced_routes'
class ApplicationController < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Flash
  # register Sinatra::AdvancedRoutes
  # register Sinatra::Auth

  helpers ApplicationHelper
  helpers TransactionsHelper
  helpers HomeHelper
  helpers TeasHelper
  helpers BlogsHelper
  helpers Sinatra::FormHelpers
  
  enable :sessions, :logging, :dump_errors, :raise_errors, :static, :method_override

  # css/js/view配置文档
  use ImageHandler
  use SassHandler
  use CoffeeHandler
  use AssetHandler

  # config in CoffeeHandler/SassHandler
  #load css/js/font file
  #get "/js/:file" do
  #  disposition_file("javascripts")
  #end
  #get "/css/:file" do
  #  disposition_file("stylesheets")
  #end

  #def disposition_file(file_type)
  #  file = File.join(ENV["APP_ROOT_PATH"],"app/assets/#{file_type}/#{params[:file]}")
  #  send_file(file, :disposition => :inline) if File.exist?(file)
  #end

  def remote_ip
    request.env["REMOTE_ADDR"] || "n-i-l"
  end

  def remote_path
    request.env["REQUEST_PATH"] || "/"
  end

  def remote_browser
    request.env["HTTP_USER_AGENT"] || "n-i-l"
  end

  def run_shell(cmd)
    IO.popen(cmd) { |stdout| stdout.reject(&:empty?) }.unshift($?.exitstatus.zero?)
  end 

  # 404 page
  not_found do
    haml :"shared/not_found", layout: :"layouts/layout", views: ENV["VIEW_PATH"]
  end

  # import for collect routes
  #def get_with_collect_route path, opts = {}, &bk
  #  @global_routes ||= []
  #  @global_routes.push({
  #    :path => path,
  #    :opts => opts,
  #    :bk   => bk || nil
  #  })
  #  _get path, opts = {}, &bk
  #end
  #alias_method :_get, :get
  #alias_method :get, :get_with_collect_route
end
