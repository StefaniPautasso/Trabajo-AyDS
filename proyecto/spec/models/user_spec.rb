# frozen_string_literal: true

require 'spec_helper'
require './models/user'

RSpec.describe
  User,type: :model do
  describe 'validations' do
    let(:user) { User.new(name: 'UserTest', password: 'passwordTest') }

    context 'when valid attributes are provided' do
      it 'is valid with a name and password' do
        expect(user).to be_valid
      end
    end

    context 'when name is missing' do
      it 'is not valid without a name' do
        user.name = nil
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("can't be blank")
      end
    end

    context 'when password is missing' do
      it 'is not valid without a password' do
        user.password = nil
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("can't be blank")
      end
    end

    context 'when name is duplicated' do
      before do
        User.create(name: 'UserTest', password: 'passwordTest')
      end

      it 'is not valid with a duplicate name' do
        user.password = 'differentPasswordTest'
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include('has already been taken')
      end
    end
  end

  describe 'password validations' do
    let(:user) { User.new(name: 'UserTest') }

    context 'when password is too short' do
      it 'is not valid with a short password' do
        user.password = 'short'
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('La contraseña debe tener por lo menos 8 caracteres')
      end
    end

    context 'when password contains spaces' do
      it 'is not valid with a password containing spaces' do
        user.password = 'password with spaces'
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('La contraseña no puede contener espacios en blanco')
      end
    end
  end

  describe 'name validations' do
    let(:user) { User.new(password: 'passwordTest') }

    context 'when name contains spaces' do
      it 'is not valid with a name containing spaces' do
        user.name = 'User Test'
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include('El nombre de usuario no puede contener espacios en blanco')
      end
    end
  end
end
