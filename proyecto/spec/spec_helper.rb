ENV['RACK_ENV'] = 'test'

require_relative '../server.rb'
require 'rspec'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    App
  end

  config.before(:suite) do
    ActiveRecord::Base.logger = nil
    ActiveRecord::Base.establish_connection(:test)
    load "#{App.root}/db/schema.rb"
  end

  config.after(:each) do
    ActiveRecord::Base.connection.close
  end
end

