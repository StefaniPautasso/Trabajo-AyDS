# frozen_string_literal: true

require 'spec_helper'
require './models/lesson'
require './models/section'

RSpec.describe 
  Lesson, type: :model do
  let(:section) { Section.create(title: 'Test Section') }

  describe 'validations' do
    describe 'with valid attributes' do
      let(:lesson) do
        Lesson.new(
          title: 'Test Lesson',
          content: 'Lesson content',
          lesson_type: :identify,
          section: section
        )
      end

      it 'is valid with a title, content, and lesson_type' do
        expect(lesson).to be_valid
      end
    end

    describe 'title validations' do
      let(:lesson) { Lesson.new(content: 'Lesson content', lesson_type: :identify, section: section) }

      it 'is invalid without a title' do
        expect(lesson).not_to be_valid
        expect(lesson.errors[:title]).to include("can't be blank")
      end
    end

    describe 'content validations' do
      let(:lesson) { Lesson.new(title: 'Test Lesson', lesson_type: :identify, section: section) }

      it 'is invalid without content' do
        expect(lesson).not_to be_valid
        expect(lesson.errors[:content]).to include("can't be blank")
      end
    end

    describe 'lesson_type validations' do
      let(:lesson) { Lesson.new(title: 'Test Lesson', content: 'Lesson content', section: section) }

      it 'is invalid without lesson_type' do
        expect(lesson).not_to be_valid
        expect(lesson.errors[:lesson_type]).to include("can't be blank")
      end
    end

    describe 'section validations' do
      let(:lesson) do
        Lesson.new(
          title: 'Test Lesson',
          content: 'Lesson content',
          lesson_type: :identify
        )
      end

      it 'is invalid without a section' do
        expect(lesson).not_to be_valid
        expect(lesson.errors[:section]).to include("can't be blank")
      end
    end
  end
end

RSpec.describe Lesson, type: :model do
  let(:section) { Section.create(title: 'Test Section') }

  describe 'associations' do
    let(:lesson) do
      Lesson.new(
        title: 'Test Lesson',
        content: 'Lesson content',
        lesson_type: :identify,
        section: section
      )
    end

    it 'belongs to a section' do
      expect(lesson.section).to eq(section)
    end
  end
end
