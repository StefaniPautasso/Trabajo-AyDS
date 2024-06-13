require 'rack/test'
require './server'

RSpec.describe 'Test Completion', type: :integration do
  include Rack::Test::Methods

  def app
    App
  end

  let!(:user) { User.create(name: 'testuser', password: 'password123') }
  let!(:section) { Section.create(title: 'Test Section') }
  let!(:test) { Test.create(title: 'Test Test', section: section) }
  let!(:question1) { Question.create(content: 'Question 1', test: test) }
  let!(:question2) { Question.create(content: 'Question 2', test: test) }
  let!(:option1_q1) { Option.create(content: 'Option 1 for Question 1', question: question1, correct: true) }
  let!(:option2_q1) { Option.create(content: 'Option 2 for Question 1', question: question1, correct: false) }
  let!(:option1_q2) { Option.create(content: 'Option 1 for Question 2', question: question2, correct: true) }
  let!(:option2_q2) { Option.create(content: 'Option 2 for Question 2', question: question2, correct: false) }

  it 'updates the user progress after completing a test' do
    # Iniciar sesión
    post '/login', { name: 'testuser', password: 'password123' }
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/menu')

    # Completar el test
    post "/sections/#{section.id}/test", {
      "question_#{question1.id}": option1_q1.id,
      "question_#{question2.id}": option1_q2.id
    }

    # Verificar respuesta del test
    expect(last_response).to be_ok
    expect(last_response.body).to include("¡Has aprobado!")

    # Verificar progreso del usuario
    progress = Progress.find_by(user: user, test: test)
    expect(progress).to_not be_nil
    expect(progress.score).to eq(100)
  end
end

