class Habit < ApplicationRecord

  belongs_to :goal
  belongs_to :user
  has_many :occurrences, dependent: :destroy

  # all the historical configs for this habit
  has_many :configs, :class_name => 'Habit::Config', inverse_of: 'habit', dependent: :destroy

  # the current config for this habit
  belongs_to :current_config, class_name: 'Habit::Config', foreign_key: 'current_config_id', optional: true

  # Delegations
  delegate :title, :duration, :schedule, :is_skippable, :recurrence_on, :recurrence_at, to: :current_config, allow_nil: true

end
