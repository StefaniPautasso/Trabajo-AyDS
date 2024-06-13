class CreateSections < ActiveRecord::Migration[7.1]
  def change
    create_table :sections do |t|
      t.string :title, null: false

      t.timestamps
    end
  end
end
