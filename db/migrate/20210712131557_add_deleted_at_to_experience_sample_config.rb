class AddDeletedAtToExperienceSampleConfig < ActiveRecord::Migration[6.1]
  def change
    add_column :experience_sample_configs, :deleted_at, :datetime
    add_index :experience_sample_configs, :deleted_at
  end
end
