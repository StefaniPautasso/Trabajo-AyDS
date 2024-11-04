# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'

describe AdminController do
  include Rack::Test::Methods

  def app
    AdminController
  end

  let!(:section) { Section.create!(title: 'Sección de ejemplo') }
  let!(:user) { User.create!(name: 'Usuario_Ejemplo', password: 'password_ejemplo') }

  describe 'GET /menu_admin' do
    it 'renders the menu_admin template' do
      get '/menu_admin'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Menú de Administrador')
    end
  end

  describe 'GET /alta_preguntas' do
    let!(:test) { Test.create!(title: 'Test 1', section: section) }

    it 'assigns all tests and renders the alta_preguntas template' do
      get '/alta_preguntas'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Agregar Pregunta')
      expect(last_response.body).to include(test.title)
    end
  end

  describe 'POST /agregar_pregunta' do
    let!(:test) { Test.create!(title: 'Test 1', section: section) }

    context 'when the question is added successfully' do
      it 'adds a question with options and redirects to /menu_admin with a success message' do
        post '/agregar_pregunta', {
          content: 'Nueva pregunta',
          test_id: test.id,
          options: ['Opción 1', 'Opción 2', 'Opción 3', 'Opción 4'],
          correct_option: '1'
        }

        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_response.body).to include('Pregunta agregada correctamente')
      end
    end

    context 'when the question cannot be saved' do
      it 'returns an error message if saving fails' do
        allow(Question).to receive(:new).and_return(double(save: false))

        post '/agregar_pregunta', {
          content: 'Pregunta fallida',
          test_id: test.id,
          options: ['Opción 1', 'Opción 2'],
          correct_option: '0'
        }

        expect(last_response.body).to include('Hubo un problema al agregar la pregunta.')
      end
    end

    context 'when the form is not filled correctly' do
      it 'returns an error message if not all options are provided' do
        post '/agregar_pregunta', {
          content: '',
          test_id: test.id,
          options: ['Opción 1'],
          correct_option: '0'
        }

        expect(last_response.body).to include('Hubo un problema al agregar la pregunta.')
      end

      it 'returns an error message if the question is empty' do
        post '/agregar_pregunta', {
          content: '',
          test_id: test.id,
          options: ['Opción 1', 'Opción 2'],
          correct_option: '0'
        }

        expect(last_response.body).to include('Hubo un problema al agregar la pregunta.')
      end
    end
  end

  describe 'GET /consultas_preguntas' do
    let!(:test) { Test.create!(title: 'Test 1', section: section) }
    let!(:question) { Question.create!(content: 'Pregunta de ejemplo', test: test) }
    let!(:option_correct) { Option.create!(content: 'Opción correcta', question: question, correct: true) }
    let!(:option_incorrect) { Option.create!(content: 'Opción incorrecta', question: question, correct: false) }
    let!(:answer) { Answer.create!(question: question, option: option_correct, user: user) }

    it 'renders the consultas_preguntas template with correct and incorrect answers data' do
      get '/consultas_preguntas'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Consultas de Preguntas')
    end
  end
end
