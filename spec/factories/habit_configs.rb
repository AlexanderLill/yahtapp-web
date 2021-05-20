FactoryBot.define do
  factory :habit_config, class: 'Habit::Config' do
    title { Faker::Lorem.sentence(word_count: 2, random_words_to_add: 2) }
    duration { Faker::Number.within(range: 3..120) }
    recurrence_on { %w[monday tuesday wednesday thursday friday] }
    recurrence_at { "09:00, 10:00, 11:00" }
    is_skippable { Faker::Boolean.boolean }
  end
end


