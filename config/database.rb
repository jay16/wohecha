require "date"

configure do
  db_name =[ENV["APP_NAME"], ENV["RACK_ENV"]].join("_")
  db_path = "#{ENV['APP_ROOT_PATH']}/db/#{db_name}.db"
  DataMapper::setup(:default, "sqlite3://#{db_path}")

  # 加载所有models
  Dir.glob("#{ENV['APP_ROOT_PATH']}/app/models/*.rb").each do |file| 
    require file 
  end

  # 自动迁移数据库
  DataMapper.finalize.auto_upgrade!
  #DataMapper.finalize.auto_migrate!

  #启动后保证db文件有被读写权限
  system("chmod 777 #{ENV['APP_ROOT_PATH']}/db/*.db")
end

