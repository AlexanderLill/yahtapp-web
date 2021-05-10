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
      habit.current_config.schedule_occurrences
    end
  end

  def schedule_all_samplings
    ExperienceSampleConfig.all.each do |config|
      config.schedule_samplings
    end
  end

end
