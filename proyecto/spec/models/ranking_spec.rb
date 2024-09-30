require './server'
require 'rack/test'

RSpec.describe 'Ranking', type: :integration do
  before do
    @user1 = User.create(name: 'testuser', password: 'password123')
    @user2 = User.create(name: 'testuser2', password: 'password123')
    @section = Section.create(title: 'Test Section')
    @test = Test.create(title: 'Test Test', section: @section)
    Progress.create(user: @user1, test: @test, score: 80)
    Progress.create(user: @user2, test: @test, score: 100)
  end

  it 'muestra el ranking de usuarios correctamente' do
    post '/login', { name: 'testuser', password: 'password123' }
    expect(last_response.status).to eq(302)
    follow_redirect!
    get '/ranking'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Ranking de Usuarios')

    expect(last_response.body).to include('testuser2')
    expect(last_response.body).to include('testuser')

    post '/logout'
    expect(last_response.status).to eq(302)

    post '/login', { name: 'testuser2', password: 'password123' }
    expect(last_response.status).to eq(302)
    follow_redirect!

    get '/ranking'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Ranking de Usuarios')

    expect(last_response.body).to include('testuser2')
    expect(last_response.body).to include('testuser')
  end
end


