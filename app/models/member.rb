#encoding: utf-8
class Member
    include DataMapper::Resource

    property :id, Serial 
    property :email, String
    property :state, String
    property :ip, String # remote ip
    property :browser, String 
    property :created_at, DateTime
    property :updated_at, DateTime
end
