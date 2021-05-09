class CreateSamplings < ActiveRecord::Migration[6.1]
  def change
    create_table :samplings do |t|
      t.references :experience_sample_config, null: false, foreign_key: true
      t.integer :value
      t.datetime :scheduled_at, null: false
      t.datetime :sampled_at, null: true
    end
  end
end
