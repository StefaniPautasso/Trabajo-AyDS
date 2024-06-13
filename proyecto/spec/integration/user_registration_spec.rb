# spec/integration/user_registration_spec.rb

require 'rack/test'
require './server'

RSpec.describe 'User Registration', type: :integration do
  include Rack::Test::Methods

  def app
    App
  end

  it 'registers a new user' do
    post '/register', { name: 'NewUser', password: 'password123' }
    expect(User.find_by(name: 'NewUser')).to_not be_nil
    follow_redirect!
    expect(last_response).to be_ok
    expect(last_request.path).to eq('/login')
  end
end

