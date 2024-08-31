require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Login Invalid Credentials', type: :request do

  it 'shows an error message when login credentials are incorrect' do
    post '/login', { name: 'invaliduser', password: 'invalidpassword' }
    expect(last_response).to be_ok
    expect(last_response.body).to include("Por favor, verifique si ingresó correctamente los datos.")
  end
  
end

