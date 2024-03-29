require 'securerandom'

require 'rack/cors'
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

use Rack::Cors do
  allow do
    origins '*'
    resource '/users', methods: :post
    resource '/users/*', methods: :put
  end
end

before do
  content_type :json
end

helpers do
  def update_user(user, params)
    user.set_fields(params, [:app, :email], missing: :skip)
    # why doesn't default work?
    extra = params[:extra] || {}
    user.extra ||= {}
    user.extra = user.extra.merge(extra)
    user.save
  end
end

get '/' do
  200
end

post '/users' do
  param :email, String
  param :extra, Hash, default: {}

  user = User.new

  user.referer = request.referer
  user.ip = request.ip
  user.user_agent = request.user_agent

  update_user(user, params)

  status 201
  json user
end

put '/users/:id' do
  param :id, String
  param :email, String
  param :extra, Hash, default: {}

  user = User[params[:id]]
  update_user(user, params)

  status 200
  json user
end
