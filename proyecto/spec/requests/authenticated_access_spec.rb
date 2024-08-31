require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Authenticated Access', type: :request do
  before do
    @user = User.create(name: 'testuser', password: 'password123')
    env 'rack.session', { user_id: @user.id }
  end

  it 'allows access to protected routes when the user is authenticated' do
    get '/profile'
    expect(last_response).to be_ok
  end
end

