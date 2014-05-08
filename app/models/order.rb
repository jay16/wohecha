#encoding: utf-8
class Order
    include DataMapper::Resource

    property :id, Serial 
    property :out_trade_no, String
    property :quantity, String
    property :amount, String
    property :detail, String 
    property :ip, String # remote ip
    property :browser, String 
    property :created_at, DateTime
    property :updated_at, DateTime
end
