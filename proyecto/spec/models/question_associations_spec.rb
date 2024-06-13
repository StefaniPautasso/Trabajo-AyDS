# spec/models/question_spec.rb

require 'spec_helper'
require './models/question'
require './models/test'

RSpec.describe Question do
  describe 'associations' do
    it 'belongs to a test' do
      test = Test.create(title: 'Test 1')
      question = Question.new(content: 'Question content', test: test)
      expect(question.test).to eq(test)
    end
  end

  describe 'validations' do
    it 'is invalid without a test' do
      question = Question.new(content: 'Question content', test: nil)
      expect(question).to_not be_valid
      expect(question.errors[:test]).to include("can't be blank")
    end
  end
end


