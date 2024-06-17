require 'spec_helper'
require './models/progress'
require './models/user'
require './models/test'

RSpec.describe Progress, type: :model do
  let(:user) { User.create(name: 'TestUser', password: 'password123') }
  let(:section) { Section.create(title: 'Test Section') }
  let(:test) { Test.create(title: 'Test 1', section: section) }

  describe 'validations' do
    before do
      @progress = Progress.new(user: user, test: test)
    end

    it 'is valid with a score between 0 and 100' do
      @progress.score = 75
      expect(@progress).to be_valid
    end

    it 'is invalid without a score' do
      @progress.score = nil
      expect(@progress).to_not be_valid
      expect(@progress.errors[:score]).to include("can't be blank")
    end

    it 'is invalid with a score less than 0' do
      @progress.score = -1
      expect(@progress).to_not be_valid
      expect(@progress.errors[:score]).to include("must be greater than or equal to 0")
    end

    it 'is invalid with a score greater than 100' do
      @progress.score = 101
      expect(@progress).to_not be_valid
      expect(@progress.errors[:score]).to include("must be less than or equal to 100")
    end
  end
  
  describe 'associations' do
    it 'belongs to a user' do
      progress = Progress.new(score: 75, user: user)
      expect(progress.user).to eq(user)
    end

    it 'belongs to a test' do
      progress = Progress.new(score: 80, test: test)
      expect(progress.test).to eq(test)
    end
  end
end
