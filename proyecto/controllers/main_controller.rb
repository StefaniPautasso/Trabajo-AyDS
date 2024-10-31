# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'

# Clase que controla las rutas de la aplicación
class MainController < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  set :views, File.expand_path('../views', __dir__)

  get('/') { erb :welcome }

  get('/menu') { erb :menu }
end
