class AddSkippedAtToSamplings < ActiveRecord::Migration[6.1]
  def change
    add_column :samplings, :skipped_at, :datetime
  end
end
