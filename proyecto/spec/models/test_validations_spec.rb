# spec/models/test_spec.rb

require 'spec_helper'
require './models/test'

RSpec.describe Test do
  describe 'validations' do
    it 'is invalid without a title' do
      test = Test.new(title: nil, section_id: 1)
      expect(test).to_not be_valid
      expect(test.errors[:title]).to include("can't be blank")
    end

    it 'is valid with a title' do
      test = Test.new(title: 'TituloTest', section_id: 1)
      expect(test).to be_valid
    end
  end
end


