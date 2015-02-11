require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:',
  verbosity: 'quiet'
)

ActiveRecord::Base.connection.create_table :users do |table|
  table.string :username
  table.integer :reputation
  table.decimal :coins, default: 0
  table.decimal :tax, default: 30
  table.references :level
end

ActiveRecord::Base.connection.create_table :levels do |table|
  table.string :title
  table.integer :experience
end
