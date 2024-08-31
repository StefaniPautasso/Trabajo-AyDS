require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Authentication Redirect', type: :request do
  it 'redirects to /login if the user is not authenticated and tries to access a protected route' do
    get '/profile'
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/login')
  end
end

