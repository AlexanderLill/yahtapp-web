FactoryBot.define do
  factory :habit do
    title { Faker::Lorem.sentence(word_count: 2, random_words_to_add: 2) }
    goal
    user
    duration { Faker::Number.within(range: 3..120) }
    schedule {
      schedule = Montrose::Schedule.new
      schedule << Montrose.every(:week).on([:tuesday, :friday]).at("12:00")
    }
    is_template { Faker::Boolean.boolean }
    is_skippable { Faker::Boolean.boolean }
    # TODO: generate template in 2/3 of all cases

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

