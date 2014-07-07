## [我喝茶](http://wohecha.cn/)

````
bundle install
passenger start
````

## 功能列表

````
# 管理中心
# /admin/*
map("/admin")        { run AdminController }
# 茶品管理
# /teas/*
map("/teas")         { run TeasController }
# 交易管理
# /transactions/*
map("/transactions") { run TransactionsController }
# 博文管理
# /blogs/*
map("/blogs")        { run BlogsController }
# 首页/购物车
# /*
map("/")             { run HomeController }
````

# 博文管理

其实是以代码管理代码，博文框架为octopress，与该项目同路径不同文件夹；

路径信息在config/setting.yaml中octopress.path配置;

若该项目代码以nginx/apache服务，要把octopress文件夹权限设置与nginx/apache启动用户权限相同.

