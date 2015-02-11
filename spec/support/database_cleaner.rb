RSpec.configure do |config|
  config.before :each do
    ActiveRecord::Base.connection.tap do |connection|
      %w(users levels).each { |table| connection.execute("DELETE FROM #{table}") }
    end
  end
end
