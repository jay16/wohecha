# [我喝茶](http://wohecha.cn/)

## 启动服务

````
bundle install

passenger start
````

## 路由配置 

````
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
````

# 功能说明 

## 博文管理

  1. 其实是以代码管理代码，博文框架为octopress，与该项目同路径不同文件夹；
  2. 路径信息在config/setting.yaml中octopress.path配置;
  3. 若该项目代码以nginx/apache服务，要把octopress文件夹权限设置与nginx/apache启动用户权限相同.
  4. 博文图片建议以数字为序号命令,编写markdown方便，一目了然.
  5. 删除博文: 删除markdown文件/images文件夹.

# 更新日志

## 博文管理

1. 2014/07/20 15:30

  创建/编辑博文界面,图片列表使用iframe，添加新图片时只刷新iframe[src]而不影响博文内容的编辑状态.

2. 2014/08/06 23:12

  1. ERB文件生成HTML模板[快送门](http://ruby-doc.org/stdlib-1.9.3/libdoc/erb/rdoc/ERB.html)
  2. IRB调试`irb -r ./config/boot.rb`
  3. 疑惑: Gemfile只加载了thin,但使用passenger启动，加载sqlite3不报错，但读取不出数据（界面正常），而thin启动一切正常.

3. 2014/09/20 11:41 sat

  1. js测试([jasmine](http://jasmine.github.io/2.0/introduction.html))

    ````
    bundle exec rake jasmine:ci
    ````

  2. 抽取sinatra渲染代码，生成静态文件
  3. 调整图片放置结构, app/assets/images => app/asserts/images/teas/:id/*.jpg

4. 2014/09/29 14:54 mon

  1. 调整功能结构，管理权限在/cpanel
  2. rspec测试完成controller/view

