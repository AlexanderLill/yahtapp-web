class AddColorToGoals < ActiveRecord::Migration[6.1]
  def change
    add_column :goals, :color, :integer, default: 0
  end
end
