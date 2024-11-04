# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'

# Controlador de la ruta de administrador
class AdminController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)

  get('/menu_admin') { erb :menu_admin }

  get('/alta_preguntas') do
    @tests = Test.all
    erb :alta_preguntas
  end

  post '/agregar_pregunta' do
    @test = Test.find_by(id: params[:test_id])

    question = Question.new(content: params[:content], test: @test)

    unless question.save
      @error = 'Hubo un problema al agregar la pregunta.'
      @tests = Test.all
      return erb :alta_preguntas
    end

    options_params = params[:options]
    correct_option_index = params[:correct_option].to_i

    options_params.each do |option_content|
      Option.create(content: option_content, question: question)
    end

    correct_option = question.options[correct_option_index]

    correct_option&.update(correct: true)

    redirect '/menu_admin?success=Pregunta agregada correctamente'
  end

  get '/consultas_preguntas' do
    @correct_answers = calculate_top_answers(true)
    @incorrect_answers = calculate_top_answers(false)
    erb :consultas_preguntas
  end

  private

  def calculate_top_answers(correct)
    Question.joins(answers: :option)
            .where(options: { correct: correct })
            .group('questions.id, questions.content')
            .order('COUNT(answers.id) DESC')
            .limit(5)
            .count('answers.id')
  end
end
