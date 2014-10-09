require "date"

# make sure /db folder exist
db_path = File.join(ENV["APP_ROOT_PATH"], "db")
FileUtils.mkdir_p(db_path) unless File.exist?(db_path)

# configure database connection
configure do
  db_name = "%s_%s" % [ENV["APP_NAME"], ENV["RACK_ENV"]]
  db_path = "%s/db/%s.db" % [ENV["APP_ROOT_PATH"], db_name]
  DataMapper::setup(:default, "sqlite3://%s" % db_path)

  # 加载所有models
  model_path = "%s/app/models/*.rb" % ENV["APP_ROOT_PATH"]
  Dir.glob(model_path).each do |file| 
    require file 
  end

  # 自动迁移数据库
  DataMapper.finalize.auto_upgrade!
  #DataMapper.finalize.auto_migrate!

  #启动后保证db文件有被读写权限
  system("chmod 777 %s/db/*.db" % ENV["APP_ROOT_PATH"])
end

