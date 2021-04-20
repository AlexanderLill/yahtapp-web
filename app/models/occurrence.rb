class Occurrence < ApplicationRecord
  belongs_to :habit
  validate :started_at_validation, on: :update
  validate :ended_at_validation, on: :update
  validate :skipped_at_validation, on: :update

  def started_at_validation
    if started_at_changed?
      if started_at < scheduled_at
        errors.add(:ended_at, "cannot be earlier than scheduled_at date: #{scheduled_at}")
      end
      if started_at_was.present?
        errors.add(:started_at, "has already been set before")
      end
      if ended_at_was.present?
        errors.add(:started_at, "cannot be set if ended_at was already set before")
      end
      if skipped_at_was.present?
        errors.add(:started_at, "cannot be set if skipped_at was already set before")
      end
    end
  end

  def ended_at_validation
    if ended_at_changed?
      if started_at_was.nil?
        errors.add(:ended_at, "cannot be set if started_at is not set yet")
        return
      end
      if ended_at_was.present?
        errors.add(:ended_at, "has already been set before")
      end
      if ended_at <= started_at
        errors.add(:ended_at, "cannot be earlier or equal to started_at date: #{started_at}")
      end
      if skipped_at_was.present?
        errors.add(:ended_at, "cannot be set if skipped_at was already set before")
      end
    end
  end

  # TODO: can we set skipped_at before scheduled_at?
  # TODO: can we set started_at before scheduled_at?

  def skipped_at_validation
    if skipped_at_changed?
      unless habit.is_skippable
        errors.add(:skipped_at, "cannot be set the habit is not skippable")
      end
      if started_at_was.present?
        errors.add(:skipped_at, "cannot be set if started_at has been set")
      end
      if ended_at_was.present?
        errors.add(:skipped_at, "cannot be set if ended_at has been set")
      end
      if skipped_at_was.present?
        errors.add(:skipped_at, "cannot be set if skipped_at was already set before")
      end
    end
  end

  def done?
    started_at.present? and ended_at.present?
  end

end
