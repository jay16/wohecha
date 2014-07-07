require "./config/boot.rb"

map("/teas") { run TeasController }
map("/admin") { run AdminController }
map("/transactions") { run TransactionsController }
map("/blogs") { run BlogsController }
map("/") { run HomeController }


#run Sinatra::Application
#Rack::Handler::Thin.run @app, :Port => 3000
