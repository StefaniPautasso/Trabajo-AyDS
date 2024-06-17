require 'spec_helper'
require './models/user'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with a name and password' do
      user = User.new(name: 'UserTest', password: 'passwordTest')
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user = User.new(password: 'passwordTest')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without a password' do
      user = User.new(name: 'UserTest')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end
    
    it 'is not valid with a duplicate name' do
      User.create(name: 'UserTest', password: 'passwordTest')
      user = User.new(name: 'UserTest', password: 'differentPasswordTest')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("has already been taken")
    end
    
    it 'is not valid with a short password' do
      user = User.new(name: 'UserTest', password: 'short')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("La contraseña debe tener por lo menos 8 caracteres")
    end
    
    it 'is not valid with a password containing spaces' do
      user = User.new(name: 'UserTest', password: 'password with spaces')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("La contraseña no puede contener espacios en blanco")
    end

    it 'is not valid with a name containing spaces' do
      user = User.new(name: 'User Test', password: 'passwordTest')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("El nombre de usuario no puede contener espacios en blanco")
    end
  end
end
