class AddSelfReportConfigToGoal < ActiveRecord::Migration[6.1]
  def change
    add_column :experience_sample_configs, :goal_id, :integer, references: :goals
  end
end
