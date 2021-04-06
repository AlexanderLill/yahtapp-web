FactoryBot.define do
  factory :habit do
    title { Faker::Lorem.sentence(word_count: 2, random_words_to_add: 2) }
    goal
    user
    duration { Faker::Number.within(range: 3..120) }
    schedule { Montrose::Schedule.new}
    is_template { Faker::Boolean.boolean }
    is_skippable { Faker::Boolean.boolean }
    # TODO: generate template in 2/3 of all cases
  end
end

