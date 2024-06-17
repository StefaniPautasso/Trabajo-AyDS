require 'spec_helper'
require './models/question'
require './models/test'
require './models/section'

RSpec.describe Question, type: :model do
  describe 'validations' do
    let(:section) { Section.create(title: 'Section 1') }
    let(:test) { Test.create(title: 'Test 1', section: section) }

    it 'is valid with content and a test' do
      question = Question.new(content: 'Example question', test: test)
      expect(question).to be_valid
    end  
  
    it 'is invalid without content' do
      question = Question.new(content: nil, test: test)
      expect(question).to_not be_valid
      expect(question.errors[:content]).to include("can't be blank")
    end

    it 'is invalid without a test' do
      question = Question.new(content: 'Example question', test: nil)
      expect(question).to_not be_valid
      expect(question.errors[:test]).to include("can't be blank")
    end   
  end
  
  describe 'associations' do
    it 'belongs to a test' do
      section = Section.create(title: 'Section 1')
      test = Test.create(title: 'Test 1', section: section)
      question = Question.new(content: 'Question content', test: test)
      expect(question.test).to eq(test)
    end    
  end
end


