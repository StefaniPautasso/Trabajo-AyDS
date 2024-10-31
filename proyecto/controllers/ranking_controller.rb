# frozen_string_literal: true

require 'sinatra/base'

# Controlador de la ruta de ranking
class RankingController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)

  get '/ranking' do
    @rankings = User.where(is_deleted: false).order(total_score: :desc).limit(10)
    erb :ranking
  end
end
