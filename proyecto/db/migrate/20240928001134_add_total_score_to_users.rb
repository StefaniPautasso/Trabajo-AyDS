# frozen_string_literal: true

# Modelo de añadir puntuación total a un usuario.
class AddTotalScoreToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :total_score, :integer, default: 0
  end
end
