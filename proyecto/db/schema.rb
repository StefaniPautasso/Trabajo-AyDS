# frozen_string_literal: true

# Este archivo es autogenerado a partir del estado actual de la base de datos. En lugar
# de editar este archivo, por favor utiliza la característica de migraciones de Active Record para
# modificar tu base de datos de manera incremental y luego regenera esta definición de esquema.
#
# Este archivo es la fuente que Rails usa para definir tu esquema cuando ejecutas `bin/rails
# db:schema:load`. Al crear una nueva base de datos, `bin/rails db:schema:load` tiende a
# ser más rápido y potencialmente menos propenso a errores que ejecutar todas tus
# migraciones desde cero. Las migraciones antiguas pueden fallar al aplicarse correctamente si esas
# migraciones usan dependencias externas o código de la aplicación.
#
# Es altamente recomendable que registres este archivo en tu sistema de control de versiones.

ActiveRecord::Schema[7.1].define(version: 2024_10_13_180_149) do
  create_table 'answers', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.integer 'question_id', null: false
    t.integer 'option_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[option_id], name: 'index_answers_on_option_id'
    t.index %w[question_id], name: 'index_answers_on_question_id'
    t.index %w[user_id], name: 'index_answers_on_user_id'
  end

  create_table 'lessons', force: :cascade do |t|
    t.integer 'lesson_type', null: false
    t.string 'title', null: false
    t.text 'content', null: false
    t.integer 'section_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[section_id], name: 'index_lessons_on_section_id'
  end

  create_table 'options', force: :cascade do |t|
    t.text 'content', null: false
    t.boolean 'correct', default: false
    t.integer 'question_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[question_id], name: 'index_options_on_question_id'
  end

  create_table 'progresses', force: :cascade do |t|
    t.integer 'score', null: false
    t.integer 'user_id', null: false
    t.integer 'test_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'timed_mode', default: false
    t.index %w[test_id], name: 'index_progresses_on_test_id'
    t.index %w[user_id], name: 'index_progresses_on_user_id'
  end

  create_table 'questions', force: :cascade do |t|
    t.text 'content', null: false
    t.integer 'test_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[test_id], name: 'index_questions_on_test_id'
  end

  create_table 'sections', force: :cascade do |t|
    t.string 'title', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'tests', force: :cascade do |t|
    t.string 'title'
    t.integer 'section_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[section_id], name: 'index_tests_on_section_id'
  end

  create_table 'user_sections', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.integer 'section_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[section_id], name: 'index_user_sections_on_section_id'
    t.index %w[user_id section_id], name: 'index_user_sections_on_user_id_and_section_id', unique: true
    t.index %w[user_id], name: 'index_user_sections_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'password', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'is_deleted', default: false
    t.integer 'total_score', default: 0
    t.boolean 'admin', default: false, null: false
  end

  add_foreign_key 'answers', 'options'
  add_foreign_key 'answers', 'questions'
  add_foreign_key 'answers', 'users'
  add_foreign_key 'lessons', 'sections'
  add_foreign_key 'options', 'questions'
  add_foreign_key 'progresses', 'tests'
  add_foreign_key 'progresses', 'users'
  add_foreign_key 'questions', 'tests'
  add_foreign_key 'tests', 'sections'
  add_foreign_key 'user_sections', 'sections'
  add_foreign_key 'user_sections', 'users'
end
