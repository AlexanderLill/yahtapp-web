class AddTitleToHabits < ActiveRecord::Migration[6.1]

  def up
    add_column :habits, :title, :string

    Habit.all.each do |habit|
      title = habit.current_config.title
      habit.update!(title: title)
    end

    remove_column :habit_configs, :title
  end


  def down
    add_column :habit_configs, :title, :string

    Habit.all.each do |habit|
      title = habit.title
      habit.current_config.update!(title: title)
    end

    remove_column :habits, :title
  end
end
