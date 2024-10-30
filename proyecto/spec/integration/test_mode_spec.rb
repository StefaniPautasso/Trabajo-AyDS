# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require './server'

RSpec.describe 'Test Completion', type: :integration do
  before do
    @user = User.create(name: 'testuser', password: 'password123')
    @section = Section.create(title: 'Test Section')
    @test = Test.create(title: 'Test Test', section: @section)
    @question = Question.create(content: 'Sample Question', test: @test)
    @option = Option.create(content: 'Sample Option', correct: true, question: @question)

    post '/login', name: 'testuser', password: 'password123'
    follow_redirect!
  end

  it 'completes the test successfully' do
    post "/sections/#{@section.id}/select_test_mode", test_mode: 'normal'
    follow_redirect!

    post "/sections/#{@section.id}/test", "question_#{@question.id}" => @option.id
    follow_redirect!

    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('¡Has aprobado!')
  end
end
