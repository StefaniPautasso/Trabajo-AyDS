# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'

# Controlador de la ruta de perfil
class ProfileController < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  set :views, File.expand_path('../views', __dir__)

  helpers do
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end

  get '/profile' do
    @user = current_user
    @progress = Progress.includes(test: { questions: { options: :answers } }).where(user_id: @user.id)
    erb :profile
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
