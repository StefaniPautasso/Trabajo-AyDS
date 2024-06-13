# spec/models/section_spec.rb

require 'spec_helper'
require './models/section'

RSpec.describe Section do
  describe 'validations' do
    it 'is valid with a title' do
      section = Section.new(title: 'Section 1')
      expect(section).to be_valid
    end

    it 'is invalid without a title' do
      section = Section.new(title: nil)
      expect(section).to_not be_valid
      expect(section.errors[:title]).to include("can't be blank")
    end
  end
end

