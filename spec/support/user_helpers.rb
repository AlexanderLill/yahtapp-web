require 'faker'
require 'factory_bot_rails'

module UserHelpers
  # actually creates the user in the DB
  def create_user
    FactoryBot.create(:user,
                      username: Faker::Internet.username,
                      email: Faker::Internet.email,
                      password: Faker::Internet.password
    )
  end

  # just returns the attributes
  def build_user
    FactoryBot.build(:user,
                     username: Faker::Internet.username,
                     email: Faker::Internet.email,
                     password: Faker::Internet.password
    )
  end

end