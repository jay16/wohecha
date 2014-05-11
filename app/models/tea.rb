#encoding: utf-8
class Tea
    include DataMapper::Resource

    property :id, Serial 
    property :image, String # image
    property :name, String, :required => true # name
    property :market, String # market desc, eg, 2014 spring recommand 
    property :blog, String # tea describtion blog link 
    property :from, String # produce source 
    property :price, Float, :required => true # price 
    property :unit1, String # price unit 
    property :unit2, String # product unit 
    property :weight, Float # weight 
    property :unit3, String # weight unit
    property :desc, String  # describtion
    property :onsale, Boolean,  :default => false # whether onsale
    property :ip, String      # remote ip that last modified
    property :browser, String # browser that last modified with
    property :created_at, DateTime, :default => DateTime.now
    property :updated_at, DateTime, :default => DateTime.now
end
