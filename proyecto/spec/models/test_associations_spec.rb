# spec/models/test_spec.rb

require 'spec_helper'
require './models/test'
require './models/section'

RSpec.describe Test do
  describe 'associations' do
    it 'belongs to a section' do
      section = Section.create(title: 'Section 1')
      test = Test.new(title: 'Test 1', section: section)
      expect(test.section).to eq(section)
    end

    it 'is invalid without a section' do
      test = Test.new(title: 'Test 1', section: nil)
      expect(test).to_not be_valid
      expect(test.errors[:section]).to include("can't be blank")
    end
  end
end


