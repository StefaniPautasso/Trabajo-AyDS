class AddIsDeletedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :is_deleted, :boolean, default: false
  end
end
