# frozen_string_literal: true

# Modelo de un progreso.
class AddTimedModeToProgress < ActiveRecord::Migration[7.1]
  def change
    add_column :progresses, :timed_mode, :boolean, default: false
  end
end
