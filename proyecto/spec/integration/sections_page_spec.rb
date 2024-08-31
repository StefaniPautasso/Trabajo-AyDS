require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Sections Page', type: :integration do

  before do
    post '/register', { name: 'NewUser', password: 'password123' }
  end

  it 'displays all the sections successfully' do
    Section.create(title: 'Section 1')
    Section.create(title: 'Section 2')
    get '/sections'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Section 1')
    expect(last_response.body).to include('Section 2')
  end

end

