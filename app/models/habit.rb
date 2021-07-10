class Habit < ApplicationRecord
  acts_as_paranoid # soft delete

  belongs_to :goal
  belongs_to :user
  has_many :occurrences, dependent: :destroy
  belongs_to :template, class_name: 'Habit', optional: true
  has_many :habit_reflections, dependent: :destroy
  has_many :reflections, through: :habit_reflections

  validates :title, presence: true
  validates :is_template, inclusion: [false], if: :template_id? # cannot be template if associated with template
  validates :template_id, absence: true, if: :is_template? # must not have association to template if is_template

  # all the historical configs for this habit
  has_many :configs, :class_name => 'Habit::Config', inverse_of: 'habit'

  # the current config for this habit
  belongs_to :current_config, class_name: 'Habit::Config', foreign_key: 'current_config_id', optional: true

  # Delegate to habit_config so attributes are available on habit as well
  delegate :duration, :schedule, :is_skippable, :is_enabled, :recurrence_on, :recurrence_at, to: :current_config, allow_nil: true

  before_destroy :before_destroy
  after_recover :reschedule_occurrences # after soft delete recovery

  def before_destroy
    destroy_occurrences
    destroy_configs
  end

  def destroy_occurrences
    if deleted?
      occurrences.delete_all
    else
      occurrences.where("scheduled_at >= ?", DateTime.now).delete_all
    end
  end

  def reschedule_occurrences
    current_config.schedule_occurrences(DateTime.now)
  end

  # we're manually doing the destroy since there is a circular dependency between habit <-> current_config
  # that results in a ForeignKey violation otherwise
  def destroy_configs
    if deleted?
      Habit.transaction do
        config = current_config
        update({current_config: nil})
        config.destroy
        Config.where(habit_id: id).delete_all
      end
    end
  end

  # Creates a clone of the habit (including its habit config)
  def clone(user)
    unless self.is_template?
      raise "Only templates can be duplicated."
    end

    new_habit = self.dup
    new_habit.is_template = false
    new_habit.user = user
    new_habit.template_id = self.id
    new_config = self.current_config.dup
    new_habit.current_config = new_config
    new_config.habit = new_habit
    new_habit.save!

    new_habit
  end

  def enable
    self.set_is_enabled(true)
  end

  def disable
    self.set_is_enabled(false)
  end

  private
    def set_is_enabled(is_enabled = true)
      ActiveRecord::Base.transaction do
        new_config = current_config.dup
        new_config.is_enabled=is_enabled
        new_config.save!
        self.current_config = new_config
        self.save!
        raise ActiveRecord::Rollback unless errors.empty?
      end
    end

end
