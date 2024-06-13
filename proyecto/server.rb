require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'

set :environment, :development
set :database_file, './config/database.yml'
set :public_folder, 'public'

enable :sessions

require './models/user'
require './models/test'
require './models/option'
require './models/section'
require './models/question'
require './models/lesson'
require './models/progress'
require './models/answer'

class App < Sinatra::Application

    def initialize(app = nil)
        super()
    end
    
    helpers do
      def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      end
    end

    get '/' do
      erb :welcome
    end

    get '/login' do
      erb :login
    end

    post '/login' do
      name = params[:name]
      password = params[:password]
      user = User.find_by(name: name, password: password)
      if user
        session[:user_id] = user.id
        redirect '/menu'
      else
        @error = "Por favor, verifique si ingresó correctamente los datos."
        erb :login
      end
    end

    get '/register' do
      erb :register
    end

    post '/register' do
      name = params[:name]
      password = params[:password] 
      existing_user = User.find_by(name: name)
      if existing_user
        @error = "El nombre de usuario ya está registrado. Por favor, elige otro."
        erb :register
      else
        user = User.create(name: name, password: password)
        session[:user_id] = user.id
        redirect '/login?registration_success=true'
      end
    end

    get '/menu' do
      erb :menu
    end

    get '/sections' do
      @sections = Section.all
      erb :sections
    end

    get '/sections/:id' do
      @section = Section.find(params[:id])
      erb :section
    end

    get '/sections/:section_id/lessons/:id' do
      @section = Section.find(params[:section_id])
      @lesson = @section.lessons.find(params[:id])
      erb :lesson
    end
    
    get '/profile' do
      if session[:user_id]
        @user = User.find(session[:user_id])
        erb :profile
      else
        redirect '/login'
      end
    end

    get '/sections/:section_id/test' do
      @section = Section.find(params[:section_id])
      @test = @section.test
      @questions = @test.questions
      erb :test
    end

    post '/sections/:section_id/test' do
      section = Section.find(params[:section_id])
      test = section.test
      questions = test.questions
      correct_answers = 0
      total_questions = questions.count
      questions.each do |question|
        selected_option_id = params["question_#{question.id}"]
        selected_option = Option.find(selected_option_id)
        correct_answers += 1 if selected_option.correct
      end
      score = (correct_answers.to_f / total_questions * 100).round(2)
      if session[:user_id]
        user_id = session[:user_id]
        progress = Progress.find_or_create_by(user_id: user_id, test_id: test.id)
        progress.update(score: score)
      end
      @message = score >= 50 ? "¡Has aprobado!" : "No has aprobado. Inténtalo de nuevo."
      @score = correct_answers
      @total_questions = total_questions
      @percentage = score
      erb :test_result
    end

    get '/progress' do
      if session[:user_id]
        @user = User.find(session[:user_id])
        @progress = Progress.includes(test: :section).where(user_id: @user.id)
        erb :progress
      else
        redirect '/login'
      end
    end
    
    get '/logout' do
      session.clear
      redirect '/login'
    end

    post '/logout' do
      session.clear
      redirect '/login'
    end
end
App.run! if $PROGRAM_NAME == __FILE__
