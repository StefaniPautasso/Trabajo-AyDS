require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'

# Requerir modelos después de activerecord
require './models/user'
require './models/test'
require './models/option'
require './models/section'
require './models/question'
require './models/lesson'

# Mover la configuración de la base de datos después de los requerimientos
# Configuración de la base de datos
set :database_file, './config/database.yml'


# Definir modelo de usuario
class User < ActiveRecord::Base
end

# Rutas
get '/' do
  erb :welcome
end

get '/login' do
  erb :login
end

post '/login' do
  username = params[:username]
  password = params[:password]
  
  user = User.find_by(username: username, password: password)
  if user
    redirect '/sections'
  else
    redirect '/register'
  end
end

get '/register' do
  erb :register
end

post '/register' do
  username = params[:username]
  password = params[:password]
  
  existing_user = User.find_by(username: username)
  if existing_user
    @error = "El nombre de usuario ya está registrado. Por favor, elige otro."
    erb :register
  else
    user = User.create(username: username, password: password)
    redirect '/login'
  end
end

# Rutas para secciones
get '/sections' do
  @sections = Section.all
  erb :sections
end

get '/sections/:id' do
  @section = Section.find(params[:id])
  erb :section
end

# Rutas para lecciones de una sección
get '/sections/:section_id/lessons/:id' do
  @section = Section.find(params[:section_id])
  @lesson = @section.lessons.find(params[:id])
  erb :lesson
end

# Ruta para mostrar el test de una sección
get '/sections/:section_id/test' do
  @section = Section.find(params[:section_id])
  @test = @section.test
  @questions = @test.questions
  erb :test
end

post '/sections/:section_id/test/:id/answer' do
  question = Question.find(params[:id])
  selected_option_id = params[:answer]

  if selected_option_id
    selected_option = Option.find(selected_option_id)
    
    if selected_option.correct
      @result = "¡Correcto!"
    else
      @result = "Incorrecto. La respuesta correcta es: #{question.correct_option.option_text}"
    end
  else
    @result = "Debes seleccionar una opción."
  end

  @section = Section.find(params[:section_id])
  erb :answer_result
end

