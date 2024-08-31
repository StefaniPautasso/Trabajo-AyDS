require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Section Page', type: :integration do

  before do
    @section = Section.create(title: 'Test Section')
    post '/register', { name: 'NewUser', password: 'password123' }
  end

  it 'displays the section successfully' do
    get "/sections/#{@section.id}"
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Test Section')
  end

end

