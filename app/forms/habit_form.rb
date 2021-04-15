class HabitForm
  include ActiveModel::Model

  attr_accessor :goal_id, :is_template, :user_id, :user, :title, :duration, :schedule, :recurrence_on, :recurrence_at, :is_skippable, :created_at, :updated_at

  validates :title, presence: true


  def initialize(params= {})
    if params[:id].present?
      @habit = Habit.find(params[:id])
      @config = @habit.current_config
      self.attributes=habit_params(params)
      self.attributes=config_params(params)
    else
      @habit = Habit.new(habit_params(params))
      @config = Habit::Config.new(config_params(params))
      super(params)
    end
  end

  # used to create a new habit
  def save(params = {})
    return false unless valid?

    ActiveRecord::Base.transaction do
      @config.habit = @habit
      @config.save!
      @habit.current_config = @config
      @habit.save!
      raise ActiveRecord::Rollback unless errors.empty?
    end
    errors.empty?
  end

  # used to update an existing habit
  def update(params = {})
    return false unless valid?

    ActiveRecord::Base.transaction do
      @habit.update!(habit_params(params))
      new_config = @config.dup
      puts @config.attributes
      puts new_config.attributes
      new_config.attributes = config_params(params)

      new_config.save!
      @config = new_config
      @habit.current_config = new_config
      @habit.save!
      raise ActiveRecord::Rollback unless errors.empty?
    end
    errors.empty?
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Habit')
  end

  def persisted?
    @habit.nil? ? false : @habit.persisted?
  end

  def id
    @habit.nil? ? nil : @habit.id
  end

  def config_params(params)
    params.slice(:title, :duration, :schedule, :is_skippable, :recurrence_on, :recurrence_at)
  end

  def habit_params(params)
    params.slice(:goal_id, :is_template, :user_id)
  end

  private
  # ...
end