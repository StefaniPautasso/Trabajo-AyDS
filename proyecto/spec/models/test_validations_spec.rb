require 'spec_helper'
require './models/test'

RSpec.describe Test do
  describe 'validations' do
    it 'is invalid without a title' do
      test = Test.new(title: nil, section: Section.new)
      expect(test).to_not be_valid
      expect(test.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without a section' do
      test = Test.new(title: 'TituloTest', section: nil)
      expect(test).to_not be_valid
      expect(test.errors[:section]).to include("can't be blank")
    end

    it 'is valid with a title and section' do
      section = Section.create(title: 'Section 1')
      test = Test.new(title: 'TituloTest', section: section)
      expect(test).to be_valid
    end
  end
end

