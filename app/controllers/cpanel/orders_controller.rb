#encoding: utf-8 
require "json"
class Cpanel::OrdersController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/orders"

  before do; authenticate!; end

  # index
  get "/" do
    @transactions = Transaction.all

    haml :index, layout: :"../layouts/layout"
  end
end
