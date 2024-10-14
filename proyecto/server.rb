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

class App < Sinatra::Application

  enable :sessions
    
  before do
    unless ['/', '/register', '/login', '/logout', '/welcome'].include?(request.path_info) || current_user
      redirect '/login'
    end
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

    @user = User.find_by(name: name)
    
    if @user && @user.password == password
      if @user.active?
        session[:user_id] = @user.id
        if @user.admin?
          redirect '/menu_admin'
        else
          redirect '/menu'
        end
      else
        @error = "Esta cuenta ha sido eliminada. No puedes iniciar sesión."
        erb :login
      end
    else
      @error = "Por favor, verifique si ingresó correctamente los datos."
      erb :login
    end
  end

  get '/register' do
    erb :register
  end

  post '/register' do
    @user = User.new(name: params[:name], password: params[:password])
      
    if @user.save
      session[:user_id] = @user.id
      redirect '/login?registration_success=true'
    else
      erb :register, locals: { error_messages: @user.errors.full_messages }
    end
  end

  get '/menu_admin' do
    erb :menu_admin
  end

  get '/alta_preguntas' do
    @tests = Test.all
    erb :alta_preguntas
  end

  post '/agregar_pregunta' do
    test_id = params[:test_id]
    content = params[:content]
    options_params = params[:options] 
    correct_option_index = params[:correct_option].to_i

    test = Test.find_by(id: test_id)
  
    unless test
      @error = "Test no encontrado."
      @tests = Test.all
      return erb :alta_preguntas
    end

    question = Question.new(content: content, test: test)
  
    if question.save
      options_params.each_with_index do |option_content, index|
        option = Option.new(content: option_content, question: question)
        option.save
      end

      correct_option = question.options[correct_option_index]
      if correct_option
        correct_option.update(correct: true)
      else
        @error = "Opción no válida."
        erb :alta_preguntas
      end

      redirect '/menu_admin?success=Pregunta agregada correctamente'
    else
      @error = "Hubo un problema al agregar la pregunta."
      @tests = Test.all
      erb :alta_preguntas
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
      @user = current_user
      @progress = Progress.includes(test: { questions: { options: :answers } }).where(user_id: @user.id)
      erb :profile
  end

  get '/sections/:section_id/test' do
    @section = Section.find(params[:section_id])
    @test = @section.test
    @questions = @test.questions
    
    @test_mode = session[:test_mode]
  
    if @test_mode == 'timed'
    elsif @test_mode == 'normal'
    end
    
    erb :test 
  end

  post '/sections/:section_id/test' do
    @section = Section.find(params[:section_id])
    @test = @section.test
    @questions = @test.questions
    @test_mode = params[:test_mode]

    responses = []
    correct_answers = 0

    @questions.each do |question|
      selected_option_id = params["question_#{question.id}"]
      
      if selected_option_id.nil? && @test_mode == 'timed'
        responses << { question_id: question.id, option_id: nil } 
      elsif selected_option_id
        selected_option = Option.find(selected_option_id)
        correct_answers += 1 if selected_option.correct
        responses << { question_id: question.id, option_id: selected_option.id }
      end
    end

    if current_user
      Answer.save_user_responses(current_user.id, @test, responses)
      progress = Progress.find_or_create_by(user_id: current_user.id, test_id: @test.id)
      progress.calculate_score(@test)

      total_score = Progress.where(user_id: current_user.id).sum(:score)
      current_user.update(total_score: total_score)
    end

    @message = progress.score >= 50 ? "¡Has aprobado!" : "No has aprobado. Inténtalo de nuevo."
    @score = correct_answers
    @total_questions = @questions.count
    @percentage = progress.score
    
    erb :test_result
    
  end

  get '/sections/:id/select_test_mode' do
    @section = Section.find(params[:id])
    erb :select_test_mode
  end

  post '/sections/:section_id/select_test_mode' do
    @section = Section.find(params[:section_id])
    @test_mode = params[:test_mode]
  
    session[:test_mode] = @test_mode
  
    redirect to("/sections/#{@section.id}/test")
  end

  get '/progress' do
    @user = current_user
    @progress = Progress.includes(test: { questions: { options: :answers } }).where(user_id: @user.id)
    erb :progress
  end
   
  post '/logout' do
    session.clear
    redirect '/'
  end
  get '/ranking' do
    @rankings = User.where(is_deleted: false)
                    .order(total_score: :desc)
                    .limit(10)
  
    erb :ranking
  end

  post '/delete_account' do
    user = current_user
    if user
      if user.mark_as_deleted
        session.clear
        flash[:notice] = "Tu cuenta ha sido eliminada. Vuelve pronto!"
        redirect '/'
      else
        flash[:alert] = "No se pudo eliminar la cuenta. Intenta nuevamente."
        redirect '/profile'
      end
    else
      flash[:alert] = "ERROR, intenta nuevamente."
      redirect '/profile'
    end
  end  

end
App.run! if $PROGRAM_NAME == __FILE__