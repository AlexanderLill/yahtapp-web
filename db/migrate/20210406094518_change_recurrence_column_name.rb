class ChangeRecurrenceColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :habits, :reccurence, :schedule
  end
end
