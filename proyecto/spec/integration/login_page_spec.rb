require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Login Page', type: :integration do

  it 'renders the login page successfully' do
    get '/'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Bienvenido')
  end
  
end
