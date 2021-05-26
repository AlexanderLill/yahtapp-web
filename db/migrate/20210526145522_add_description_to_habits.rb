class AddDescriptionToHabits < ActiveRecord::Migration[6.1]
  def change
    add_column :habits, :description, :text
  end
end
