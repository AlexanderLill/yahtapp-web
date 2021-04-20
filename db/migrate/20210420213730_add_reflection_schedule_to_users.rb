class AddReflectionScheduleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :reflection_on, :string
    add_column :users, :reflection_at, :string
  end
end
