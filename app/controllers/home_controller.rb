#encoding: utf-8 
class HomeController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/home"

  # root
  get "/" do
    haml :index
  end

  get "/home" do
    @teas = Tea.all

    erb :home 
  end

  get "/cart" do
    @teas = Tea.all
    #@teas.each { |tea| tea.update(:price => tea.id * 0.01) }
    haml :cart, layout: :"../layouts/layout"
  end

  get "/transactions" do
    @transactions = Transaction.all

    haml :transactions, layout: :"../layouts/layout"
  end


  # post /checkout
  post "/checkout" do
    options = {
      :partner           => Settings.alipay.pid,
      :key               => Settings.alipay.secret,
      :seller_email      => Settings.alipay.seller_email,
      :description       => params[:order],
      :out_trade_no      => Time.now.to_i.to_s,
      :subject           => "我喝茶订单 - ￥" + params[:amount].to_s,
      :price             => params[:amount],
      :quantity          => 1,
      :discount          => '0.00',
      :return_url        => Settings.alipay.return_url,
      :notify_url        => Settings.alipay.notify_url
    }
    redirect AlipayDualfun.trade_create_by_buyer_url(options)
  end

  # post /transactions/notify
  post "/transactions/notify" do
    find_or_create_transaction!

    haml :notify
  end

  # get /transactions/done
  get "/transactions/done" do
    find_or_create_transaction!

    flash[:notice] = "付款成功啦!"
    redirect "/", :notice => "done"
  end

  # show
  # get /transactions/:out_trade_no
  get "/transactions/:out_trade_no" do
    @transaction = Transaction.first(:out_trade_no => params[:out_trade_no])
    haml :modal
  end

  def find_or_create_transaction!
    # %(WAIT_SELLER_SEND_GOODS WAIT_SELLER_SEND_GOODS).include?(params[:trade_status])
    transaction = Transaction.all(:out_trade_no => params[:out_trade_no]).first
    status = "action: "
    if transaction.nil?
      params.merge!({ created_at: DateTime.now, updated_at: DateTime.now })
      status += "create; status: "
      status += Transaction.create(params).to_s
    else
      params.merge!({ updated_at: DateTime.now })
      status += "update; status: "
      status += transaction.update(params).to_s
    end
    status
  end

  def chk_params(tea_id)
    params[:tea] && params[:tea].to_i == tea_id ? 1 : 0
  end

  not_found do
    "sorry"
    #haml :not_fount
  end
end
