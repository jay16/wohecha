require "date"
configure do
  db_name =[ENV["APP_NAME"], ENV["RACK_ENV"]].join("_")
  DataMapper::setup(:default, "sqlite3://#{ENV['APP_ROOT_PATH']}/db/#{db_name}.db")

  # 加载所有models
  Dir.glob("#{ENV['APP_ROOT_PATH']}/app/models/*.rb").each { |file| require file }

  # 自动迁移数据库
  DataMapper.finalize.auto_upgrade!
  #DataMapper.finalize.auto_migrate!

=begin
  IO.readlines("./tea.txt").each do |line|
    array = line.split
    hash = {
      :name => array[0],
      :image => array[1],
      :from => array[2],
      :price => array[3],
      :unit1 => array[4],
      :unit2 => array[5],
      :weight => array[6],
      :unit3 => array[7],
      :desc => array[8]
    }
    Tea.create(hash)
  end
=end
end

