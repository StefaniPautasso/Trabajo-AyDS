# frozen_string_literal: true

# Modelo de la creación de una pregunta.
class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.text :content, null: false
      t.references :test, null: false, foreign_key: true

      t.timestamps
    end
  end
end
