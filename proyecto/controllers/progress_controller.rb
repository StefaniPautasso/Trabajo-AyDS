# frozen_string_literal: true

require 'sinatra/base'

# Controlador de la ruta de progreso
class ProgressController < Sinatra::Base
  enable :sessions
  set :views, File.expand_path('../views', __dir__)

  helpers do
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end

  get '/progress' do
    @user = current_user
    @progress = Progress.where(user_id: @user.id)
    erb :progress
  end
end
