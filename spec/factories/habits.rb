FactoryBot.define do
  factory :habit do
    goal
    user
    is_template { Faker::Boolean.boolean }

    after(:create) do |habit|
      habit.current_config = create(:habit_config, habit: habit)
      habit.save
    end

    factory :daily_habit do
      schedule {
        schedule = Montrose::Schedule.new
        schedule << Montrose.every(:week).on([:monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday]).at(Time.current.strftime("%H:%M"))
      }
    end

    factory :empty_habit do
      schedule {
        schedule = Montrose::Schedule.new
      }
    end
  end
end

