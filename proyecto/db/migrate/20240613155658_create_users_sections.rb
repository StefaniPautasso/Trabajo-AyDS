class CreateUsersSections < ActiveRecord::Migration[7.1]
  def change
    create_table :user_sections do |t|
      t.references :user, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true

      t.timestamps
    end
    add_index :user_sections, [:user_id, :section_id], unique: true
  end
end
