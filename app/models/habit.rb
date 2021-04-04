class Habit < ApplicationRecord
  belongs_to :goal
  belongs_to :user
  serialize :recurrence, Montrose::Recurrence

end
