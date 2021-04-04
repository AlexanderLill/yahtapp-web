class CreateHabits < ActiveRecord::Migration[6.1]
  def change
    create_table :habits do |t|
      t.string :title
      t.references :goal, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :recurrence
      t.integer :duration
      t.boolean :is_template
      t.boolean :is_skippable
      t.string :type

      t.timestamps
    end
  end
end
