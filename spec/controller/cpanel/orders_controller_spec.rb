#encoding:utf-8
require File.expand_path "../../../spec_helper.rb", __FILE__

describe "Cpanel::OrdersController" do
  describe "should unauthorized without login" do
    it "should be foribbid when visit /cpanel/orders" do
      get "/cpanel/orders"

      expect(last_response).to_not be_ok
      expect(last_response.status).to be(302)
      expect(last_response).to be_redirect

      follow_redirect!
      expect(last_request.url).to eq(redirect_url("/cpanel/login"))
    end
  end

  describe "should operation within login" do
    before:all do
      post "/cpanel/login", { 
        :name     => Settings.login.name, 
        :password => Settings.login.password
      }

      expect(last_response).to be_redirect
      expect(last_response.status).to be(302)

      follow_redirect!
      expect(last_request.url).to eq(redirect_url("/cpanel"))
    end
    it "should show orders list" do
      get "/cpanel/orders"

      h1 = "订单列表"
      expect(last_response).to be_ok
      expect(last_response.body).to include(h1)
    end
  end
end
