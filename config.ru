require "./config/boot.rb"


# 公开界面
# 首页/购物车 /*
map("/")             { run HomeController }
# 支付宝支付
map("/transactions") { run TransactionsController }

# 需要登陆权限
# 管理中心
map("/cpanel")        { run Cpanel::HomeController }
# 茶品管理
map("/cpanel/teas")   { run Cpanel::TeasController }
# 订单管理
map("/cpanel/orders") { run Cpanel::OrdersController }
# 博文管理
map("/cpanel/blogs")  { run Cpanel::BlogsController }

#run Sinatra::Application
#Rack::Handler::Thin.run @app, :Port => 3000
