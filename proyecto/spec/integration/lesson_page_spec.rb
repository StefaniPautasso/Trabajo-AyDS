# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require './app'

RSpec
  .describe 'Lesson Access', type: :integration do
  include Rack::Test::Methods

  before do
    @user = User.create(name: 'testuser', password: 'password123')
    @section = Section.create(title: 'Test Section')

    @invalid_lesson = Lesson.create(
      title: nil,
      section: @section,
      content: 'Invalid lesson content'
    )

    @lesson = Lesson.create(
      title: 'Test Lesson',
      section: @section,
      content: 'Lesson content goes here.',
      lesson_type: :identify
    )

    puts "Lesson successfully created with ID: #{@lesson.id}" if @lesson.persisted?
  end

  it 'allows the user to access a specific lesson' do
    post '/login', { name: 'testuser', password: 'password123' }
    expect(last_response.status).to eq(302)

    follow_redirect!
    expect(last_request.path).to eq('/menu')

    get "/sections/#{@section.id}/lessons/#{@lesson.id}"

    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Lesson content goes here.')
  end
end
