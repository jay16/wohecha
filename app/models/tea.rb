#encoding: utf-8
class Tea
    include DataMapper::Resource

    property :id, Serial 
    property :image, String # image
    property :name, String # name
    property :from, String # 产地
    property :price, Float # 价格
    property :unit1, String # 价格单位
    property :unit2, String # 产品单位
    property :weight, Float # 净重
    property :unit3, String # 净重单位
    property :desc, String
end
