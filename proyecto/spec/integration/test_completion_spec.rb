require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Test Completion', type: :integration do
  
  before do
    @user = User.create(name: 'testuser', password: 'password123')
    @section = Section.create(title: 'Test Section')
    @test = Test.create(title: 'Test Test', section: @section)
    @question1 = Question.create(content: 'Question 1', test: @test)
    @question2 = Question.create(content: 'Question 2', test: @test)
    @option1_q1 = Option.create(content: 'Option 1 for Question 1', question: @question1, correct: true)
    @option2_q1 = Option.create(content: 'Option 2 for Question 1', question: @question1, correct: false)
    @option1_q2 = Option.create(content: 'Option 1 for Question 2', question: @question2, correct: true)
    @option2_q2 = Option.create(content: 'Option 2 for Question 2', question: @question2, correct: false)
  end

  it 'updates the user progress after completing a test' do
  
    post '/login', { name: 'testuser', password: 'password123' }
    expect(last_response.status).to eq(302)

    follow_redirect!
    expect(last_request.path).to eq('/menu')

    post "/sections/#{@section.id}/test", {
      "question_#{@question1.id}": @option1_q1.id,
      "question_#{@question2.id}": @option1_q2.id
    }

    expect(last_response.status).to eq(200)

    expect(last_response.body).to include("¡Has aprobado!")

    progress = Progress.find_by(user: @user, test: @test)
    expect(progress).to_not be_nil
    expect(progress.score).to eq(100)
  end
  
end

