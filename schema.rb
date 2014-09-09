require_relative 'app'

DB.drop_table :users if DB.table_exists?(:users)

DB.create_table :users do
  uuid :id, primary_key: true
  String :email
  json :extra, default: Sequel::Postgres::JSONHash.new({}), null: false
  DateTime :created_at
  DateTime :updated_at
end
