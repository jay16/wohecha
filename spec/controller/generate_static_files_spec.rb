#encoding: utf-8
require File.expand_path '../../spec_helper.rb', __FILE__

describe "GenerateStaticFiles" do
  def response; last_response; end
  def request;  last_request;  end

  def generate_static_template(response, file)
    static_home = File.join(ENV["APP_ROOT_PATH"], "app/views/home", file)
    File.open(static_home, "a+") do |file|
      file.puts response.body
    end
  end

  it "generate /home files" do
    get "/admin/template?template=home" 
    generate_static_template(response, "home.erb")
  end

  it "generate /cart browser files" do
    get "/admin/template?template=cart" 
    generate_static_template(response, "cart.erb")
  end

  it "generate /cart mobile browser files" do
    get "/admin/template?template=cart&mobile=true"
    generate_static_template(response, "mobile_cart.erb")
  end
end

