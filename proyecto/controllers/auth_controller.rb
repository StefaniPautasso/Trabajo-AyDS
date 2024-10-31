# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'

# Controlador de autenticación
class AuthController < Sinatra::Base
  enable :sessions
  set :views, File.expand_path('../views', __dir__)

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

  post('/logout') do
    session.clear
    redirect '/'
  end
end
