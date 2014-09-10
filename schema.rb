require_relative 'app'

DB.drop_table :users if DB.table_exists?(:users)

DB.create_table :users do
  uuid :id, primary_key: true
  String :app
  String :email
  json :extra, default: Sequel::Postgres::JSONHash.new({}), null: false
  String :ip
  String :referer
  String :user_agent
  DateTime :created_at
  DateTime :updated_at
end
