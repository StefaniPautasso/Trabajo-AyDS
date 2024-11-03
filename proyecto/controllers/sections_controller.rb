# frozen_string_literal: true

require 'sinatra/base'

# Controlador de las secciones
class SectionsController < Sinatra::Base
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  set :views, File.expand_path('../views', __dir__)

  get('/sections') do
    @sections = Section.all
    erb :sections
  end

  get('/sections/:id') do
    @section = Section.find(params[:id])
    erb :section
  end

  get '/sections/:section_id/lessons/:id' do
    @section = Section.find(params[:section_id])
    @lesson = @section.lessons.find(params[:id])
    erb :lesson
  end

  get '/sections/:section_id/test' do
    @section = Section.find(params[:section_id])
    @test = @section.test
    @questions = @test.questions
    @test_mode = session[:test_mode]

    erb :test
  end

  post '/sections/:section_id/test' do
    @section = Section.find(params[:section_id])
    @test = @section.test
    @questions = @test.questions
    @test_mode = session[:test_mode] || params[:test_mode]

    responses = collect_responses(@questions, @test_mode)

    if current_user
      progress = save_progress(@test, responses)
      @message, @score, @total_questions, @percentage = generate_test_results(progress, responses)
      erb :test_result
    else
      redirect to("/sections/#{@section.id}")
    end
  end

  get '/sections/:section_id/select_test_mode' do
    @section = Section.find(params[:section_id])
    erb :select_test_mode
  end

  post '/sections/:section_id/select_test_mode' do
    session[:test_mode] = params[:test_mode]
    redirect to("/sections/#{params[:section_id]}/test")
  end

  private

  def collect_responses(questions, test_mode)
    questions.each_with_object([]) do |question, responses|
      selected_option_id = params["question_#{question.id}"]

      if selected_option_id.nil? && test_mode == 'timed'
        responses << { question_id: question.id, option_id: nil }
      elsif selected_option_id
        responses << { question_id: question.id, option_id: selected_option_id }
      end
    end
  end

  def save_progress(test, responses)
    Answer.save_user_responses(current_user.id, test, responses)
    progress = Progress.find_or_create_by(user_id: current_user.id, test_id: test.id)
    progress.calculate_score(test)
    current_user.update(total_score: Progress.where(user_id: current_user.id).sum(:score))
    progress
  end

  def generate_test_results(progress, responses)
    message = progress.score >= 50 ? '¡Has aprobado!' : 'No has aprobado. Inténtalo de nuevo.'
    score = responses.count { |r| r[:option_id] && Option.find(r[:option_id]).correct }
    [message, score, responses.size, progress.score]
  end
end
