namespace :schedule do
  desc "Schedules occurrences based on the current configuration of a habit"
  task occurrences: :environment do
    schedule_all_occurrences
  end

  desc "Schedules samplings based on existing configuration"
  task samplings: :environment do
    schedule_all_samplings
  end

  desc "Schedules everything"
  task all: :environment do
    schedule_all_occurrences
    schedule_all_samplings
  end

  def schedule_all_occurrences
    Habit.all.each do |habit|
      # ensures that schedule is based on user's timezone
      Time.use_zone(habit.user.timezone) do
        habit.current_config.schedule_occurrences(DateTime.now)
      end
    end
  end

  def schedule_all_samplings
    ExperienceSampleConfig.all.each do |config|
      # ensures that schedule is based on user's timezone
      Time.use_zone(config.user.timezone) do
        config.schedule_samplings(DateTime.now)
      end
    end
  end

end
