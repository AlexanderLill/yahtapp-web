class OnboardingController < ApplicationController
  before_action :authenticate_user!

  layout 'boxed'

  def index

  end

  # view for selecting habits that will be cloned
  def habits
    @goals = Habit.where(is_template: true).where(goal: { is_template: true}).includes([:goal, :current_config]).group_by{ |habit| habit.goal_id }
  end

  def set_habits

  end

  def reflection_settings

  end

  def set_reflection_settings

  end

  def sampling_settings

  end

  def set_sampling_settings

  end

  def client

  end

end