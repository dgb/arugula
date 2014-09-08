require 'securerandom'

require 'sequel'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/param'

DB = Sequel.connect ENV['DATABASE_URL']
DB.extension :pg_json
Sequel::Model.plugin :json_serializer

class User < Sequel::Model
  def before_create
    self.id = SecureRandom.uuid
    super
  end
end

before do
  content_type :json
end

get '/' do
  200
end

post '/users' do
  param :email, String
  param :attrs, Hash, default: {}

  user = User.new
  user.set_fields(params, [:email, :attrs])
  # why doesn't default work?
  user.attrs ||= {}
  user.save

  status 201
  json user
end
