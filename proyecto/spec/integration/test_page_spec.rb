require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Test Page', type: :integration do

  before do
    @user = User.create(name: 'testuser', password: 'password123')
    @section = Section.create(title: 'Test Section')
    @test = Test.create(title: 'Test Test', section: @section)
    post '/register', { name: 'NewUser', password: 'password123' }
  end

  it 'renders the test page successfully' do
    get "/sections/#{@section.id}/test"
    expect(last_response.status).to eq(200)
    expect(last_response.body).to match(/Test de #{@section.title}/)
  end
  
end
