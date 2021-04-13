FactoryBot.define do
  factory :occurrence do
    habit
    scheduled_at { Date.current }
    started_at { nil}
    ended_at { nil }
    skipped_at { nil }
  end
end

