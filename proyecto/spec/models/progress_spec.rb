require 'spec_helper'
require './models/progress'
require './models/user'
require './models/test'
require './models/section'
require './models/question'
require './models/option'
require './models/answer'

RSpec.describe Progress, type: :model do
  let(:user) { User.create(name: 'TestUser', password: 'password123') }
  let(:section) { Section.create(title: 'Test Section') }
  let(:test) { Test.create(title: 'Test 1', section: section) }
  let(:question1) { Question.create(content: 'Question 1', test: test) }
  let(:question2) { Question.create(content: 'Question 2', test: test) }
  let(:option1) { Option.create(content: 'Option 1', question: question1, correct: true) }
  let(:option2) { Option.create(content: 'Option 2', question: question1, correct: false) }
  let(:option3) { Option.create(content: 'Option 1', question: question2, correct: true) }
  let(:option4) { Option.create(content: 'Option 2', question: question2, correct: false) }
  
  before do
    Answer.create(user: user, question: question1, option: option1)
    Answer.create(user: user, question: question2, option: option3)
  end

  describe 'validations' do
    before do
      @progress = Progress.new(user: user, test: test, score:0)
    end
    
    it 'is valid with a score, test and user' do
      expect(@progress).to be_valid
    end
    
    it 'is invalid without a score' do
      @progress.score = nil
      expect(@progress).to_not be_valid
      expect(@progress.errors[:score]).to include("can't be blank")
    end
    
    it 'is invalid without a test' do
      @progress.test = nil
      expect(@progress).to_not be_valid
      expect(@progress.errors[:test]).to include("can't be blank")
    end
    
    it 'is invalid without a user' do
      @progress.user = nil
      expect(@progress).to_not be_valid
      expect(@progress.errors[:user]).to include("can't be blank")
    end
          
    it 'is valid with a score between 0 and 100' do
      @progress.score = 75
      expect(@progress).to be_valid
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

  describe 'calculate_score' do
    before do
      @progress = Progress.create(user: user, test: test)
    end

    it 'calculates the correct score' do
      @progress.calculate_score(test)
      expect(@progress.score).to eq(100.0)
    end

    it 'saves the score to the progress record' do
      @progress.calculate_score(test)
      expect(@progress.reload.score).to eq(100.0)
    end

    it 'calculates a score of 50 for one correct answer out of two questions' do
      Answer.where(user: user, question: question2).destroy_all
      @progress.calculate_score(test)
      expect(@progress.score).to eq(50.0)
    end

    it 'calculates a score of 0 for no correct answers' do
      Answer.where(user: user, question: question1).destroy_all
      Answer.where(user: user, question: question2).destroy_all
      Answer.create(user: user, question: question1, option: option2)
      Answer.create(user: user, question: question2, option: option4)
      @progress.calculate_score(test)
      expect(@progress.score).to eq(0.0)
    end
  end
end

