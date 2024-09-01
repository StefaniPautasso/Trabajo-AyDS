require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Registration Page', type: :request do

  it 'renders the registration page successfully' do
    get '/register'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Registrarse')
  end
end

