class Habit < ApplicationRecord

  belongs_to :goal
  belongs_to :user
  has_many :occurrences, dependent: :destroy

  has_many :habit_reflections
  has_many :reflections, through: :habit_reflections

  # all the historical configs for this habit
  has_many :configs, :class_name => 'Habit::Config', inverse_of: 'habit'

  # the current config for this habit
  belongs_to :current_config, class_name: 'Habit::Config', foreign_key: 'current_config_id', optional: true

  # Delegations
  delegate :title, :duration, :schedule, :is_skippable, :recurrence_on, :recurrence_at, to: :current_config, allow_nil: true

  before_destroy :destroy_configs

  # we're manually doing the destroy since there is a circular dependency between habit <-> current_config
  # that results in a ForeignKey violation otherwise
  def destroy_configs
    Habit.transaction do
      config = current_config
      update({current_config: nil})
      config.destroy
      Config.where(habit_id: id).delete_all
    end
  end
end
