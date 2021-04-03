class CreateGoals < ActiveRecord::Migration[6.1]
  def change
    create_table :goals do |t|
      t.string :title
      t.text :description
      t.boolean :is_template, default: false
      t.references :template, foreign_key: { to_table: :goals }
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
