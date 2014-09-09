require 'securerandom'

require 'sequel'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/param'

DB = Sequel.connect ENV['DATABASE_URL']
DB.extension :pg_json

Sequel::Model.plugin :json_serializer
Sequel::Model.plugin :timestamps, update_on_create: true

class User < Sequel::Model
  def before_create
    self.id = SecureRandom.uuid
    super
  end
end

before do
  content_type :json
end

helpers do
  def update_user(user, params)
    user.set_fields(params, [:email, :extra])
    # why doesn't default work?
    user.extra ||= {}
    user.save
  end
end

get '/' do
  200
end

post '/users' do
  param :email, String
  param :attrs, Hash, default: {}

  user = User.new
  update_user(user, params)

  status 201
  json user
end
