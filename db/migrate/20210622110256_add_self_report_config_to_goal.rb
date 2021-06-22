class AddSelfReportConfigToGoal < ActiveRecord::Migration[6.1]
  def change
    add_column :goals, :experience_sample_config_id, :integer, :references => :experience_sample_config
  end
end
