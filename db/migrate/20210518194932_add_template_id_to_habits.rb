class AddTemplateIdToHabits < ActiveRecord::Migration[6.1]
  def change
    add_column :habits, :template_id, :integer, :references => :habits
  end
end
