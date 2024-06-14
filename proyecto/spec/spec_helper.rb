ENV['RACK_ENV'] = 'test'

require 'rack/test'
require './server.rb'
require 'rspec'
require 'active_record'
require 'database_cleaner'

RSpec.configure do |config|

  config.include Rack::Test::Methods

  def app
    App
  end
  
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(:test)
    ActiveRecord::Migration.maintain_test_schema!
  end

  config.before(:each) do
    ActiveRecord::Base.connection.begin_transaction(joinable: false)
  end

  config.after(:each) do
    ActiveRecord::Base.connection.rollback_transaction
  end 
  
end

=begin
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(:test)
    ActiveRecord::Migration.maintain_test_schema!
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
=end
