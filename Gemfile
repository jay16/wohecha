#encoding: utf-8
source "http://ruby.taobao.org"

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end
#sinatra
gem "sinatra", "~>1.4.5"
gem "sinatra-reloader"
gem "sinatra-flash"
#gem "sinatra-advanced-routes", :require => "sinatra/advanced_routes"
#gem "yard-sinatra"
#gem "sinatra-redirect-with-flash"
#gem "sinatra-formhelpers"
#gem "sinatra_more"
#gem "sinatra-mapping"

#db
gem "dm-core", "~>1.2.1"
gem "dm-migrations", "~>1.2.0"
gem "dm-timestamps", "~>1.2.0"
#gem "sqlite3"
gem "dm-sqlite-adapter", "~>1.2.0"

#assets
gem "haml", "~> 4.0.5"
gem "sass", "~>3.3.7"
gem "therubyracer", "~>0.12.1"
gem "coffee-script", "~>2.2.0"

#gem "passenger"
gem "thin", "~>1.6.2"
gem "rake", "~>10.3.2"
gem "settingslogic", "~>2.0.9"

#代码覆盖率
#rake stats
gem "code_statistics"

gem "alipay_dualfun", :github => "happypeter/alipay_dualfun"

# for erb operation
gem "tilt", "~>1.4.1"

# for markdown render
gem "redcarpet"
gem "rdiscount"
gem "bluecloth"
gem "kramdown"
gem "maruku"


group :test do
  gem "rack-test", "~>0.6.2"
  gem "rspec", "~>2.14.1"
  #gem "capybara", "~>2.4.3"
  #gem "selenium-webdriver", "~>2.43.0"
  #gem "chromedriver-helper", "~>0.0.7"
  gem "factory_girl", "~>4.4.0"
  gem "jasmine", "~>2.0.2"
end
