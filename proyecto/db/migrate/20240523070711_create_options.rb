class CreateOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :options do |t|
      t.text :option_text
      t.boolean :correct, default: false
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
