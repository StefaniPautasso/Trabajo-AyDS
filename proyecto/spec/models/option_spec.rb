require 'spec_helper'
require './models/option'
require './models/question'
require './models/test'
require './models/section'

RSpec.describe Option, type: :model do
  let(:section) { Section.create(title: 'Section 1') }
  let(:test) { Test.create(title: 'Test 1', section: section) }
  let(:question) { Question.create(content: 'Question content', test: test) }

  describe 'validations' do
    before do
      @option = Option.new(content: 'Option content', question: question)
    end

    it 'is valid with content and a question' do
      expect(@option).to be_valid
    end
    
    it 'is invalid without content' do
      @option.content = nil
      expect(@option).to_not be_valid
      expect(@option.errors[:content]).to include("can't be blank")
    end

    it 'is invalid without a question' do
      @option.question = nil
      expect(@option).to_not be_valid
      expect(@option.errors[:question]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a question' do
      option = Option.new(content: 'Option content', question: question)
      expect(option.question).to eq(question)
    end
  end
end
