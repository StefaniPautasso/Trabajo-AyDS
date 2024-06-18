require 'spec_helper'
require './models/answer'
require './models/user'
require './models/question'
require './models/option'
require './models/test'
require './models/section'

RSpec.describe Answer, type: :model do
  let(:user) { User.create(name: 'TestUser', password: 'password123') }
  let(:section) { Section.create(title: 'Section 1') }
  let(:test) { Test.create(title: 'Test 1', section: section) }
  let(:question1) { Question.create(content: 'Example question 1', test: test) }
  let(:question2) { Question.create(content: 'Example question 2', test: test) }
  let(:option1) { Option.create(content: 'Option content 1', question: question1, correct: true) }
  let(:option2) { Option.create(content: 'Option content 2', question: question1, correct: false) }
  let(:option3) { Option.create(content: 'Option content 1', question: question2, correct: true) }
  let(:option4) { Option.create(content: 'Option content 2', question: question2, correct: false) }

  describe 'validations' do
    it 'is valid with a user, question and option' do
      answer = Answer.new(user: user, question: question1, option: option1)
      expect(answer).to be_valid
    end
    
    it 'is invalid without a user' do
      answer = Answer.new(user: nil, question: question1, option: option1)
      expect(answer).to_not be_valid
      expect(answer.errors[:user]).to include("can't be blank")
    end
    
   it 'is invalid without a question' do
      answer = Answer.new(user: user, question: nil, option: option1)
      expect(answer).to_not be_valid
      expect(answer.errors[:question]).to include("can't be blank")
    end
    
    it 'is invalid without a option' do
      answer = Answer.new(user: user, question: question1, option: nil)
      expect(answer).to_not be_valid
      expect(answer.errors[:option]).to include("can't be blank")
    end 
  end
  
  describe 'associations' do
    it 'belongs to a user' do
      answer = Answer.new(user: user, question: question1, option: option1)
      expect(answer.user).to eq(user)
    end

    it 'belongs to a question' do
      answer = Answer.new(user: user, question: question1, option: option1)
      expect(answer.question).to eq(question1)
    end

    it 'belongs to an option' do
      answer = Answer.new(user: user, question: question1, option: option1)
      expect(answer.option).to eq(option1)
    end
  end

  describe 'save_user_responses' do
    it 'saves user responses and deletes old ones' do
      old_answer = Answer.create(user: user, question: question1, option: option2)
      
      responses = [
        { question_id: question1.id, option_id: option1.id },
        { question_id: question2.id, option_id: option3.id }
      ]
      
      Answer.save_user_responses(user.id, test, responses)
      
      expect(Answer.where(user_id: user.id).count).to eq(2)
      expect(Answer.where(user_id: user.id, question_id: question1.id).first.option).to eq(option1)
      expect(Answer.where(user_id: user.id, question_id: question2.id).first.option).to eq(option3)
    end

    it 'creates new answers if none exist' do
      responses = [
        { question_id: question1.id, option_id: option1.id },
        { question_id: question2.id, option_id: option3.id }
      ]
      
      Answer.save_user_responses(user.id, test, responses)
      
      expect(Answer.where(user_id: user.id).count).to eq(2)
      expect(Answer.where(user_id: user.id, question_id: question1.id).first.option).to eq(option1)
      expect(Answer.where(user_id: user.id, question_id: question2.id).first.option).to eq(option3)
    end

    it 'replaces old answers with new ones' do
      old_answer1 = Answer.create(user: user, question: question1, option: option2)
      old_answer2 = Answer.create(user: user, question: question2, option: option4)
      
      responses = [
        { question_id: question1.id, option_id: option1.id },
        { question_id: question2.id, option_id: option3.id }
      ]
      
      Answer.save_user_responses(user.id, test, responses)
      
      expect(Answer.where(user_id: user.id).count).to eq(2)
      expect(Answer.where(user_id: user.id, question_id: question1.id).first.option).to eq(option1)
      expect(Answer.where(user_id: user.id, question_id: question2.id).first.option).to eq(option3)
    end

    it 'cleans up old answers when questions are removed' do
      old_answer1 = Answer.create(user: user, question: question1, option: option2)
      old_answer2 = Answer.create(user: user, question: question2, option: option4)
      
      responses = [
        { question_id: question1.id, option_id: option1.id }
      ]
      
      Answer.save_user_responses(user.id, test, responses)
      
      expect(Answer.where(user_id: user.id).count).to eq(1)
      expect(Answer.where(user_id: user.id, question_id: question1.id).first.option).to eq(option1)
    end
  end
end
