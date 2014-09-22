require "./config/boot.rb"


# 管理中心 /admin/*
map("/admin")        { run AdminController }
# 茶品管理 /admin/teas/*
map("/admin/teas")         { run TeasController }
# 交易管理 /admin/transactions/*
map("/admin/transactions") { run TransactionsController }
# 博文管理 /blogs/*
map("/admin/blogs")        { run BlogsController }
# 首页/购物车 /*
map("/")             { run HomeController }

#run Sinatra::Application
#Rack::Handler::Thin.run @app, :Port => 3000
