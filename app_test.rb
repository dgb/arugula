ENV['RACK_ENV'] = 'test'

require 'bundler/setup'

require_relative 'app'
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

def app
  Sinatra::Application
end

before do
  DB[:users].truncate
end

describe 'GET /' do
  it 'responds with 200' do
    get '/'
    last_response.must_be :ok?
  end
end

describe 'POST /users' do
  let(:email) { 'derek@example.com' }
  let(:user) { User.last }

  before do
    post '/users', email: email, attrs: {foo: 'bar'}
  end

  it 'adds a user' do
    user.email.must_equal email
    user.attrs['foo'].must_equal 'bar'
  end

  it 'responds with a 201' do
    last_response.status.must_equal 201
  end

  it 'responds with json' do
    last_response.content_type.must_equal 'application/json'
  end
end
