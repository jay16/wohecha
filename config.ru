require "./config/boot.rb"


# 管理中心 /admin/*
map("/admin")        { run AdminController }
# 茶品管理 /teas/*
map("/teas")         { run TeasController }
# 交易管理 /transactions/*
map("/transactions") { run TransactionsController }
# 博文管理 /blogs/*
map("/blogs")        { run BlogsController }
# 首页/购物车 /*
map("/")             { run HomeController }

#run Sinatra::Application
#Rack::Handler::Thin.run @app, :Port => 3000
