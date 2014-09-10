Sequel.migration do
  change do
    create_table :users do
      uuid :id, primary_key: true
      String :app
      String :email
      json :extra
      String :ip
      String :referer
      String :user_agent
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
