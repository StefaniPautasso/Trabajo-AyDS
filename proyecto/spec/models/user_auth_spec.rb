require 'spec_helper'

RSpec.describe 'User Authentication', type: :request do
  before(:each) do
    @user = User.create(name: 'testuser', password: 'password123')
  end

  describe 'Login' do
    it 'allows a user to log in if the account is active' do
      post '/login', { name: @user.name, password: @user.password }
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_request.path).to eq('/menu')
    end

    it 'prevents login for deleted accounts' do
      @user.mark_as_deleted
    
      post '/login', { name: @user.name, password: @user.password }
      expect(last_response).to be_ok
      expect(last_request.path).to eq('/login')
      expect(last_response.body).to include('Esta cuenta ha sido eliminada. No puedes iniciar sesión.')
    end
  end

  describe 'Account Deletion' do
    it 'allows a user to delete their account' do
      post '/login', { name: @user.name, password: @user.password }

      post '/delete_account'

      follow_redirect!
      expect(last_response).to be_ok
      expect(last_request.path).to eq('/')
      expect(last_response.body).to include('Tu cuenta ha sido eliminada. Vuelve pronto!')
    end
  end
end