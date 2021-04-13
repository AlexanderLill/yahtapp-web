class Occurrence < ApplicationRecord
  belongs_to :habit
  validates :started_at, absence: true, on: :update, if: Proc.new { |started_at| !started_at_was.nil? }
  validates :ended_at, absence: true, on: :update, if: Proc.new { |ended_at|  !ended_at_was.nil? }
  validates :skipped_at, absence: true, on: :update, if: Proc.new { |skipped_at| !skipped_at_was.nil? || !self.habit.is_skippable }

end
