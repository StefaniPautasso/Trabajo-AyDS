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
  let(:question) { Question.create(content: 'Example question', test: test) }
  let(:option) { Option.create(content: 'Option content', question: question) }

  describe 'associations' do
    it 'belongs to a user' do
      answer = Answer.new(user: user, question: question, option: option)
      expect(answer.user).to eq(user)
    end
    
    it 'belongs to a question' do
      answer = Answer.new(user: user, question: question, option: option)
      expect(answer.question).to eq(question)
    end
    
    it 'belongs to an option' do
      answer = Answer.new(user: user, question: question, option: option)
      expect(answer.option).to eq(option)
    end
  end
end

