# spec/models/user_spec.rb

require 'spec_helper'
require './models/user'

RSpec.describe User do
  describe 'validations' do
    it 'is valid with a name and password' do
      user = User.new(name: 'UserTest', password: 'passwordTest')
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user = User.new(password: 'passwordTest')
      expect(user).not_to be_valid
    end

    it 'is not valid without a password' do
      user = User.new(name: 'UserTest')
      expect(user).not_to be_valid
    end
  end
end


