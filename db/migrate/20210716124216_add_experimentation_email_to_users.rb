class AddExperimentationEmailToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :experimentation_email, :boolean, :default => true
  end
end
