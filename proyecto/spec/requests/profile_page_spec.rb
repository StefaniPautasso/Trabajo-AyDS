require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Profile Page', type: :request do
  before do
    @user = User.create(name: 'testuser', password: 'password123')
    @section = Section.create(title: 'Test Section')
    @test = Test.create(title: 'Test Test', section: @section)
    @question = @test.questions.create(content: 'Sample Question')
    @option = @question.options.create(content: 'Sample Option', correct: true)
    @progress = Progress.create(user: @user, test: @test, score: 75)

    env 'rack.session', { user_id: @user.id }
  end
  
  it 'loads the progress associated with the user and renders the profile template' do
    get '/profile'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Mi Perfil') 
    expect(last_response.body).to include('Bienvenido testuser') 
    expect(last_response.body).to include('Test Section') 
  end
end
