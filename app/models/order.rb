#encoding: utf-8
class Order
    include DataMapper::Resource

    property :id, Serial 
    property :out_trade_no, String # uniq id relate to alipay
    property :quantity, String # product quantity 
    property :amount, String   # total product amount
    property :detail, String   # shop cart list 
    property :status, Boolean  # whether transaction over
    property :ip, String # remote ip
    property :browser, String 
    property :created_at, DateTime
    property :updated_at, DateTime
end
