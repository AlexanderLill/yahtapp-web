require 'time'

class Habit::Config < ApplicationRecord
  include ActiveRecord::Immutable

  include Schedulable
  include_schedule :schedule

  self.table_name = "habit_configs"

  belongs_to :habit
  has_many :occurrences, through: :habit

  validates :duration, numericality: { only_integer: true}
  after_save :schedule_occurrences # TODO: later this action must be performed when a habit is *duplicated* and on a daily schedule


  def schedule_occurrences(starting_from = self.updated_at, retention_period = 7.days)
    # 1. remove all occurrences newer than current updated_at
    occurrences.where("scheduled_at >= ?", starting_from).delete_all

    # 2. create new occurrences newer than current updated_at if habit is enabled
    if is_enabled
      dates = self.get_schedule(starting: starting_from, ending: (starting_from + retention_period).at_end_of_day)
      dates.each do |date|
        Occurrence.create(habit_id: self.habit_id, scheduled_at: date)
      end
    end
  end

end
