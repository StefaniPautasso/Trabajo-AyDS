# spec/models/question_spec.rb

require 'spec_helper'
require './models/question'

RSpec.describe Question do
  describe 'validations' do
    it 'is invalid without content' do
      question = Question.new(content: nil, test_id: 1)
      expect(question).to_not be_valid
      expect(question.errors[:content]).to include("can't be blank")
    end

    it 'is valid with content' do
      section = Section.create(title: 'Section 1') #ver si es necesario
      test = Test.new(title: 'Test 1', section: section)
      question = Question.new(content: 'Example question', test: test)
      expect(question).to be_valid
    end
  end
end


