class CreateExperienceSampleConfigs < ActiveRecord::Migration[6.1]
  def change
    create_table :experience_sample_configs do |t|
      t.string :title, null: false
      t.string :prompt, null: false
      t.integer :scale_steps, null: true
      t.string :scale_label_start, null: true
      t.string :scale_label_center, null: true
      t.string :scale_label_end, null: true
      t.string :schedule, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
