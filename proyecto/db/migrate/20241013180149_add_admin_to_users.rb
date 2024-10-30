# frozen_string_literal: true

# Agrega la columna 'admin' a la tabla 'users' para indicar si un usuario es administrador.
class AddAdminToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
  end
end
