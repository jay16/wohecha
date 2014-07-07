#encoding: utf-8
source "http://ruby.taobao.org"

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end
#sinatra
gem "sinatra"
gem "sinatra-reloader"
gem "sinatra-flash"
#gem "sinatra-redirect-with-flash"
#gem "sinatra-formhelpers"
#gem "sinatra_more"
#gem "sinatra-mapping"

#db
gem "dm-core"
gem "dm-migrations"
gem "dm-timestamps"
gem "dm-sqlite-adapter"

#assets
gem "haml"
gem "sass"
gem "therubyracer"
gem "coffee-script"

#gem "passenger"
gem "thin"
gem "rake"
gem "settingslogic"

#代码覆盖率
#rake stats
gem "code_statistics"

gem "alipay_dualfun", :github => "happypeter/alipay_dualfun"


# octopress env
group :development do
 # gem 'rake', '~> 0.9'
  gem 'jekyll', '~> 0.12'
  gem 'rdiscount', '~> 2.0.7'
  gem 'pygments.rb', '~> 0.3.4'
  gem 'RedCloth', '~> 4.2.9'
  #gem 'haml', '~> 3.1.7'
  #gem 'compass', '~> 0.12.2'
  #gem 'sass', '~> 3.2'
  #gem 'sass-globbing', '~> 1.0.0'
  gem 'rubypants', '~> 0.2.0'
  gem 'rb-fsevent', '~> 0.9'
  gem 'stringex', '~> 1.4.0'
  gem 'liquid', '~> 2.3.0'
  gem 'directory_watcher', '1.4.1'
end

group :test do
  gem "rack-test"
  gem "rspec"
  #gem "capybara"
  gem "factory_girl"
end
