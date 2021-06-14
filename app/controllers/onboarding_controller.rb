class OnboardingController < ApplicationController
  before_action :authenticate_user!

  layout 'onboarding'

  def index; end

  # view for selecting habits that will be cloned
  def habits
    @goals = Habit.where(is_template: true).where(goal: { is_template: true}).includes([:goal, :current_config]).group_by{ |habit| habit.goal_id }
  end

  def set_habits
    @habit_ids = params[:habit_ids]

    # TODO: what to do with duplicate habits? e.g. the user already has a clone of that habit?

    # 1. get list of selected habits
    @habits = Habit.where(id: @habit_ids)

    if @habits.present?
      Habit.transaction do
        # 2. duplicate habits and habit config
        # the habits are now cloned but still have the old goals assigned to them
        new_habits = @habits.map{ |habit| habit.clone(current_user)}
        # 3. loop over all the new habits
        new_habits.each do |habit|
          # check if user already has a goal that was derived from that template
          existing_goal = current_user.goals.where(template_id: habit.goal_id).first
          if existing_goal.present?
            # change goal to existing user's goal with same template_id
            habit.update(goal: existing_goal)
          else
            new_goal = habit.goal.clone(current_user)
            habit.update(goal: new_goal)
          end
        end
      end
      redirect_to onboarding_reflections_path, notice: "Successfully created #{@habits.count} habits."
    else
      redirect_to onboarding_habits_path, alert: 'Please select at least one habit.'
    end
  end

  def reflection_settings
    @user = current_user
  end

  def set_reflection_settings
    @user = current_user
    if @user.update(reflection_setting_params)
      redirect_to onboarding_samplings_path, notice: 'Successfully saved reflection schedule.'
    else
      redirect_to onboarding_reflections_path, alert: 'There was an error while saving your settings.'
    end
  end

  def sampling_settings
    @sampling = ExperienceSampleConfig.new(
      title: 'Productivity',
      prompt: 'How productive did you feel in the last hour?',
      recurrence_on: ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'],
      recurrence_at: ['09:00, 10:00, 11:00, 12:00, 14:00, 15:00, 16:00, 17:00'],
      scale_steps: 7,
      scale_label_start: 'Not at all',
      scale_label_center: 'Moderately',
      scale_label_end: 'Very'
    )
  end

  def set_sampling_settings
    @sampling = ExperienceSampleConfig.new(
      user: current_user
    )
    @sampling.assign_attributes(sampling_params)
    if @sampling.save
      redirect_to onboarding_client_path, notice: 'Self-Report config was successfully created.'
    else
      redirect_to onboarding_samplings_path, alert: 'Self-Report config could not be saved.'
    end
  end

  def client; end

  def reflection_setting_params
    params.require(:user).permit(:reflection_at_string, reflection_on: [])
  end

  def sampling_params
    params.require(:experience_sample_config).permit(:title, :prompt, :user_id, :recurrence_at, :scale_steps, :scale_label_start, :scale_label_center, :scale_label_end, recurrence_on: [])
  end

end