# frozen_string_literal: true

# Modelo de la relación entre usuarios y secciones.
class CreateUsersSections < ActiveRecord::Migration[7.1]
  def change
    create_table :user_sections do |t|
      t.references :user, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true

      t.timestamps
    end
    add_index :user_sections, %i[user_id section_id], unique: true
  end
end
