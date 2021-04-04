require "application_system_test_case"

class HabitsTest < ApplicationSystemTestCase
  setup do
    @habit = habits(:one)
  end

  test "visiting the index" do
    visit habits_url
    assert_selector "h1", text: "Habits"
  end

  test "creating a Habit" do
    visit habits_url
    click_on "New Habit"

    fill_in "Duration", with: @habit.duration
    fill_in "Goal", with: @habit.goal_id
    check "Is skippable" if @habit.is_skippable
    check "Is template" if @habit.is_template
    fill_in "Reccurence", with: @habit.reccurence
    fill_in "Title", with: @habit.title
    fill_in "Type", with: @habit.type
    fill_in "User", with: @habit.user_id
    click_on "Create Habit"

    assert_text "Habit was successfully created"
    click_on "Back"
  end

  test "updating a Habit" do
    visit habits_url
    click_on "Edit", match: :first

    fill_in "Duration", with: @habit.duration
    fill_in "Goal", with: @habit.goal_id
    check "Is skippable" if @habit.is_skippable
    check "Is template" if @habit.is_template
    fill_in "Reccurence", with: @habit.reccurence
    fill_in "Title", with: @habit.title
    fill_in "Type", with: @habit.type
    fill_in "User", with: @habit.user_id
    click_on "Update Habit"

    assert_text "Habit was successfully updated"
    click_on "Back"
  end

  test "destroying a Habit" do
    visit habits_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Habit was successfully destroyed"
  end
end
