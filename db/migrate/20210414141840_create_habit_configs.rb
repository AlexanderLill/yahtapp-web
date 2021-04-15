class CreateHabitConfigs < ActiveRecord::Migration[6.1]
  def change
    create_table :habit_configs do |t|
      t.string :title
      t.references :habit, null: false, foreign_key: true
      t.string :schedule
      t.integer :duration
      t.boolean :is_skippable
      t.timestamps
    end
    change_table :habits do |t|
      t.references :current_config, foreign_key: { to_table: :habit_configs }
    end
  end
end
