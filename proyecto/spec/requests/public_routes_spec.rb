require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Public Routes', type: :request do
  it 'allows access to the welcome page without authentication' do
    get '/'
    expect(last_response).to be_ok
  end
    
  it 'allows access to the login page without authentication' do
    get '/login'
    expect(last_response).to be_ok
  end
  
  it 'allows access to the register page without authentication' do
    get '/register'
    expect(last_response).to be_ok
  end

end

