class AddTimezoneToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :timezone, :string, default: "Zurich", null: false
  end
end
