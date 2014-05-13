#encoding: utf-8
require File.expand_path '../../spec_helper.rb', __FILE__

describe "GenerateStaticFiles" do
  def response; last_response; end
  def request;  last_request;  end

  def generate_static_template(response, file)
    static_home = File.join(ENV["APP_ROOT_PATH"], file)
    File.open(static_home, "a+") do |file|
      file.puts response.body
    end
  end

  it "generate statics files" do
    %w(home cart).each do |path|
      get "/#{path}" 

      generate_static_template(response, "#{path}.erb")
    end
  end
end

