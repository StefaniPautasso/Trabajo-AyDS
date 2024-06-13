class CreateOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :options do |t|
      t.text :content, null: false
      t.boolean :correct, default: false 
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
