class CreateOccurrences < ActiveRecord::Migration[6.1]
  def change
    create_table :occurrences do |t|
      t.references :habit, null: false, foreign_key: true
      t.datetime :scheduled_at, null: false
      t.datetime :started_at, null: true
      t.datetime :ended_at, null: true
      t.datetime :skipped_at, null: true
    end
  end
end
