require 'spec_helper'
require './models/test'
require './models/section'

RSpec.describe Test, type: :model do
  let(:section) { Section.create(title: 'Section 1') }

  describe 'validations' do
    it 'is valid with a title and section' do
      test = Test.new(title: 'TituloTest', section: section)
      expect(test).to be_valid
    end
    
    it 'is invalid without a title' do
      test = Test.new(title: nil, section: section)
      expect(test).to_not be_valid
      expect(test.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without a section' do
      test = Test.new(title: 'TituloTest', section: nil)
      expect(test).to_not be_valid
      expect(test.errors[:section]).to include("can't be blank")
    end
  end
  
  describe 'associations' do   
    it 'belongs to a section' do
      test = Test.new(title: 'Test 1', section: section)
      expect(test.section).to eq(section)
    end    
  end  
end
