#encoding:utf-8
require File.expand_path '../../spec_helper.rb', __FILE__

describe "HomeController" do

  it "should show prehome page" do
    get "/"

    title = "我喝茶 | 在路上"
    expect(last_response.status).to be(200)
    expect(last_response.body).to include(title)
  end

  it "should show home page" do
    get "/home"

    expect(last_response.status).to be(200)
  end

  it "should show shop cart page" do
    get "/cart"

    expect(last_response.status).to be(200)
  end

  it "should redirect to /cpanel when get /admin" do
    redirect_url = "%s/cpanel" % example_url

    get "/admin"
    expect(last_response).to be_redirect
    expect(last_response.status).to be(302)
    expect(last_response.location).to eq(redirect_url)

    follow_redirect!
    expect(last_request.url).to eq(redirect_url)
  end

  describe "should contain products info that [onsale]" do
    before do
      post "/cpanel/login", { 
        :name     => Settings.login.name, 
        :password => Settings.login.password
      }
      # regenerate static page need login 
      post "/cpanel/generate"

      expect(last_response.body).to_not include("[失败]")
    end

    it "should contain the url redirect to [shop cart] and [blog]" do
      get "/home"

      expect(last_response).to be_ok
      @teas_onsale = Tea.all(:onsale => true)
      @teas_onsale.each do |tea|
        expect(last_response.body).to include(tea.name)
        expect(last_response.body).to include("/cart?tea=%d" % tea.id)
        expect(last_response.body).to include(tea.blog)
      end
    end

    it "should contain the teas [onsale] in shop cart when regenerate it" do
      get "/cart"

      expect(last_response).to be_ok
      @teas_onsale = Tea.all(:onsale => true)
      @teas_onsale.each do |tea|
        expect(last_response.body).to include(tea.name)
      end
    end
  end
end
