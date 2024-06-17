require 'spec_helper'
require './models/lesson'
require './models/section'

RSpec.describe Lesson, type: :model do
  let(:section) { Section.create(title: 'Test Section') }

  describe 'validations' do
    before do
      @lesson = Lesson.new(title: 'Test Lesson', content: 'Lesson content', lesson_type: :identify, section: section)
    end

    it 'is valid with a title, content, and lesson_type' do
      expect(@lesson).to be_valid
    end

    it 'is invalid without a title' do
      @lesson.title = nil
      expect(@lesson).to_not be_valid
      expect(@lesson.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without content' do
      @lesson.content = nil
      expect(@lesson).to_not be_valid
      expect(@lesson.errors[:content]).to include("can't be blank")
    end

    it 'is invalid without lesson_type' do
      @lesson.lesson_type = nil
      expect(@lesson).to_not be_valid
      expect(@lesson.errors[:lesson_type]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a section' do
      lesson = Lesson.new(title: 'Test Lesson', content: 'Lesson content', lesson_type: :identify, section: section)
      expect(lesson.section).to eq(section)
    end
  end
end
