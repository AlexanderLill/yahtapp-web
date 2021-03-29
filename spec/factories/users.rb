FactoryBot.define do
  factory :user do
    username { Faker::Internet.user_name }
    email { Faker::Internet.safe_email } # creates an email address that can never be delivered
    password { "defaultpass" }
  end
end