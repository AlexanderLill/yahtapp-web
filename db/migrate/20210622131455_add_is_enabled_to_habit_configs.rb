class AddIsEnabledToHabitConfigs < ActiveRecord::Migration[6.1]
  def change
    add_column :habit_configs, :is_enabled, :boolean, default: true
  end
end
