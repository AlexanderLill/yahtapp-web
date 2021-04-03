require 'rails_helper'

feature 'User logins using the form' do
  let (:user) { create(:user) }

  scenario 'can login using the username' do
    visit new_user_session_url

    fill_in 'user_login', with: user.username
    fill_in 'user_password', with: user.password
    click_button 'commit'

    expect(page).to have_current_path(dashboard_path)
  end
end