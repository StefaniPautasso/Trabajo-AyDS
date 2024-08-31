require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'User Registration', type: :integration do

  it 'registers a new user successfully' do
    post '/register', { name: 'NewUser', password: 'password123' }
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/login')
    expect(last_request.query_string).to include('registration_success=true')
    expect(User.find_by(name: 'NewUser')).to_not be_nil
    expect(last_response).to be_ok
  end

  it 'does not register a user with invalid credentials' do
    post '/register', { name: '', password: 'short' }
    expect(last_response).to be_ok
    expect(last_response.body).to include('Name can\'t be blank')
    expect(last_response.body).to include('La contraseña debe tener por lo menos 8 caracteres')
    expect(User.find_by(name: '')).to be_nil
  end

  it 'does not register a user with a duplicate name' do
    User.create(name: 'ExistingUser', password: 'password123')
    post '/register', { name: 'ExistingUser', password: 'differentPassword' }
    expect(last_response).to be_ok
    expect(last_response.body).to include('Name has already been taken')
    expect(User.where(name: 'ExistingUser').count).to eq(1)
  end
  
end


