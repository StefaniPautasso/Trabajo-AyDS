# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require './app'

RSpec.describe 'Authentication Redirect', type: :request do
  before do
    @user = User.create(name: 'test_user', password: 'password123')
    expect(@user).not_to be_nil
  end

  after do
    @user.destroy
  end

  it 'redirects to /login if the user is not authenticated and tries to access a protected route' do
    get '/profile'
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/login')
  end

  it 'allows access to /profile if the user is authenticated' do
    env 'rack.session', { user_id: @user.id }
    get '/profile'
    expect(last_response).not_to be_redirect
  end
end
