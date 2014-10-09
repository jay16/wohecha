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
gem 'rdiscount', '~> 2.0.7'
gem "bluecloth"
#gem "kramdown"
gem "maruku"

# for octopress command
group :development do
#  gem 'rake', '~> 0.9'
#  gem 'jekyll', '~> 0.12'
#  gem 'rdiscount', '~> 2.0.7'
#  gem 'pygments.rb', '~> 0.3.4'
#  gem 'RedCloth', '~> 4.2.9'
#  gem 'haml', '~> 3.1.7'
#  gem 'compass', '~> 0.12.2'
#  gem 'sass', '~> 3.2'
#  gem 'sass-globbing', '~> 1.0.0'
#  gem 'rubypants', '~> 0.2.0'
#  gem 'rb-fsevent', '~> 0.9'
  gem 'stringex', '~> 1.4.0'
  gem 'liquid', '~> 2.3.0'
#  gem 'directory_watcher', '1.4.1'
end

group :test do
  gem "rack-test", "~>0.6.2"
  gem "rspec", "~>2.14.1"
  #gem "capybara", "~>2.4.3"
  #gem "selenium-webdriver", "~>2.43.0"
  #gem "chromedriver-helper", "~>0.0.7"
  gem "factory_girl", "~>4.4.0"
  gem "jasmine", "~>2.0.2"
end
