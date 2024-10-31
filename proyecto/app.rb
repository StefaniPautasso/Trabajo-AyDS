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

require_relative 'controllers/auth_controller'
require_relative 'controllers/admin_controller'
require_relative 'controllers/sections_controller'
require_relative 'controllers/profile_controller'
require_relative 'controllers/progress_controller'
require_relative 'controllers/ranking_controller'
require_relative 'controllers/main_controller'

# Clase principal de la aplicación Sinatra
class App < Sinatra::Application
  enable :sessions
  use AuthController
  use AdminController
  use SectionsController
  use ProfileController
  use ProgressController
  use RankingController
  use MainController

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
end

App.run! if $PROGRAM_NAME == __FILE__
