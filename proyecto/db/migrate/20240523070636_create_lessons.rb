class CreateLessons < ActiveRecord::Migration[7.1]
  def change
    create_table :lessons do |t|
      t.string :title
      t.text :content
      t.string :lesson_type # 'preventive', 'action', 'identify'
      t.references :section, foreign_key: true

      t.timestamps
    end
  end
end
