require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Welcome Page', type: :integration do

  it 'renders the welcome page successfully' do
    get '/'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Bienvenido a Learn 2 Save')
  end
  
end
