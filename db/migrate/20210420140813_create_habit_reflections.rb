class CreateHabitReflections < ActiveRecord::Migration[6.1]
  def change
    create_table :habit_reflections do |t|
      t.references :reflection, null: false, foreign_key: true
      t.references :habit, null: false, foreign_key: true
      t.integer :rating

      t.timestamps
    end
  end
end
