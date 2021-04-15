class RemoveHabitColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :habits, :title, :string
    remove_column :habits, :duration, :integer
    remove_column :habits, :schedule, :string
    remove_column :habits, :is_skippable, :boolean
  end
end
