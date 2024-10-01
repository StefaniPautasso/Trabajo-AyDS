require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Test Mode', type: :integration do
  before do
    @user = User.create(name: 'testuser', password: 'password123')
    @section = Section.create(title: 'Test Section')
    @test = Test.create(title: 'Test Test', section: @section)

    post '/login', { name: 'testuser', password: 'password123' }
    follow_redirect!
  end

  it 'shows the timer in timed mode' do
    post "/sections/#{@section.id}/select_test_mode", {
      test_mode: 'timed'
    }
    
    follow_redirect!
    
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Tiempo restante:')
    expect(last_response.body).to match(/<div id="timer">/)
  end
  
  
  it 'hides the timer in normal mode' do
    post "/sections/#{@section.id}/select_test_mode", {
      test_mode: 'normal'
    }
    
    follow_redirect!
    
    expect(last_response.status).to eq(200)
    expect(last_response.body).not_to include('Tiempo restante:')
    expect(last_response.body).not_to match(/<div id="timer">/)
  end
end
