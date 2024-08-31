require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Logout Functionality', type: :request do
  before do
    @user = User.new(name: 'UserTest', password: 'passwordTest')
    env 'rack.session', { user_id: @user.id }
  end
  
  it 'clears the session and redirects to the welcome page' do
    post '/logout'
    expect(last_request.env['rack.session']['user_id']).to be_nil
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/')
  end
  
end
