require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'User Progress Page', type: :integration do

  before do
    post '/register', { name: 'NewUser', password: 'password123' }
  end

  it 'renders the progress page successfully' do
    get '/progress'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Progreso del Usuario')
  end
  
end


