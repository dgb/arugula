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
  #DB[:users].truncate
end

describe 'GET /' do
  it 'responds with 200' do
    get '/'
    last_response.must_be :ok?
  end
end

describe 'POST /users' do
  let(:email) { 'derek@example.com' }
  let(:user) { User.order(:updated_at).last }

  before do
    post '/users', email: email, extra: {foo: 'bar'}
  end

  it 'adds a user' do
    user.email.must_equal email
    user.extra['foo'].must_equal 'bar'
  end

  it 'responds with a 201' do
    last_response.status.must_equal 201
  end

  it 'responds with json' do
    last_response.content_type.must_equal 'application/json'
  end
end

describe 'PUT /users/:id' do
  let(:user) { User.create(email: email) }
  let(:email) { 'derek@example.com' }
  let(:new_email) { 'barnes@example.com' }

  before { put "/users/#{user.id}", email: new_email, extra: {fizz: 'buzz'} }

  it 'updates the user' do
    user.reload.email.must_equal new_email
  end

  it 'responds with a 200' do
    last_response.status.must_equal 200
  end

  it 'responds with json' do
    last_response.content_type.must_equal 'application/json'
  end

  it 'merges extra attributes' do
    put "/users/#{user.id}", extra: {foo: 'bar'}
    user.reload.extra['fizz'].must_equal 'buzz'
    user.reload.extra['foo'].must_equal 'bar'
  end
end
