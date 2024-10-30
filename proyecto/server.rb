# frozen_string_literal: true

require 'sinatra'
require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/activerecord'

set :database_file, './config/database.yml'
set :public_folder, 'public'

require './models/user'
require './models/test'
require './models/option'
require './models/section'
require './models/question'
require './models/lesson'
require './models/progress'
require './models/answer'

# Clase principal de la aplicación Sinatra
class App < Sinatra::Application
  enable :sessions

  helpers do
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def redirect_to_appropriate_menu
      admin_routes = [
        '/menu_admin', '/alta_preguntas', '/agregar_pregunta',
        '/consultas_preguntas'
      ]
      common_user_routes = [
        '/menu', '/sections', '/sections/:id',
        '/sections/:section_id/lessons/:id',
        'sections/:section_id/test', 'sections/:section_id/select_test_mode',
        '/profile', '/progress', '/ranking', '/delete_account'
      ]

      if current_user&.admin? && common_user_routes.include?(request.path_info)
        redirect '/menu_admin'
      elsif !current_user&.admin? && admin_routes.include?(request.path_info)
        redirect '/menu'
      end
    end
  end

  before do
    unless ['/', '/register', '/login', '/logout', '/welcome'].include?(request.path_info) || current_user
      redirect '/login'
    end
    redirect_to_appropriate_menu
  end

  get('/') { erb :welcome }
  get('/login') { erb :login }

  post '/login' do
    name, password = params.values_at(:name, :password)
    @user = User.find_by(name: name)

    if @user&.password == password
      if @user.active?
        session[:user_id] = @user.id
        redirect @user.admin? ? '/menu_admin' : '/menu'
      else
        @error = 'Esta cuenta ha sido eliminada. No puedes iniciar sesión.'
        erb :login
      end
    else
      @error = 'Por favor, verifique si ingresó correctamente los datos.'
      erb :login
    end
  end

  get('/register') { erb :register }

  post '/register' do
    @user = User.new(name: params[:name], password: params[:password])

    if @user.save
      session[:user_id] = @user.id
      redirect '/login?registration_success=true'
    else
      erb :register, locals: { error_messages: @user.errors.full_messages }
    end
  end

  get('/menu_admin') { erb :menu_admin }
  get('/alta_preguntas') do
    @tests = Test.all
    erb :alta_preguntas
  end

  post '/agregar_pregunta' do
    @test = Test.find_by(id: params[:test_id])
    unless @test
      @error = 'Test no encontrado.'
      return erb(:alta_preguntas)
    end

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
    unless correct_option
      @error = 'Opción no válida.'
      return erb :alta_preguntas
    end
    correct_option.update(correct: true)

    redirect '/menu_admin?success=Pregunta agregada correctamente'
  end

  get '/consultas_preguntas' do
    @correct_answers = calculate_top_answers(true)
    @incorrect_answers = calculate_top_answers(false)
    erb :consultas_preguntas
  end

  def calculate_top_answers(correct)
    Question.joins(answers: :option)
            .where(options: { correct: correct })
            .group('questions.id, questions.content')
            .order('COUNT(answers.id) DESC')
            .limit(5)
            .count('answers.id')
  end

  get('/menu') { erb :menu }
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

  get '/profile' do
    @user = current_user
    @progress = Progress.includes(test: { questions: { options: :answers } }).where(user_id: @user.id)
    erb :profile
  end

  get '/sections/:section_id/test' do
    @section = Section.find(params[:section_id])
    @test = @section.test
    @questions = @test.questions
    erb :test
  end

  post '/sections/:section_id/test' do
    @section = Section.find(params[:section_id])
    @test = @section.test
    responses = collect_responses(@test.questions, params[:test_mode])

    if current_user
      progress = save_progress(@test, responses)
      @message, @score, @total_questions, @percentage = generate_test_results(progress, responses)
      erb :test_result
    end
  end

  def collect_responses(questions, test_mode)
    questions.each_with_object([]) do |question, responses|
      selected_option_id = params["question_#{question.id}"]
      responses << if selected_option_id.nil? && test_mode == 'timed'
                     { question_id: question.id, option_id: nil }
                   else
                     { question_id: question.id, option_id: selected_option_id }
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
    score = responses.count { |r| Option.find(r[:option_id]).correct }
    [message, score, responses.size, progress.score]
  end

  get '/sections/:section_id/select_test_mode' do
    @section = Section.find(params[:section_id])
    erb :select_test_mode
  end

  post '/sections/:section_id/select_test_mode' do
    session[:test_mode] = params[:test_mode]
    redirect to("/sections/#{params[:section_id]}/test")
  end

  get('/progress') do
    @user = current_user
    @progress = Progress.where(user_id: @user.id)
    erb :progress
  end

  post('/logout') do
    session.clear
    redirect '/'
  end

  get '/ranking' do
    @rankings = User.where(is_deleted: false).order(total_score: :desc).limit(10)
    erb :ranking
  end

  post '/delete_account' do
    user = current_user
    if user&.mark_as_deleted
      session.clear
      flash[:notice] = 'Tu cuenta ha sido eliminada. ¡Vuelve pronto!'
      redirect '/'
    else
      flash[:alert] = 'No se pudo eliminar la cuenta. Intenta nuevamente.'
      redirect '/profile'
    end
  end
end

App.run! if $PROGRAM_NAME == __FILE__
