require "application_system_test_case"

class ReflectionsTest < ApplicationSystemTestCase
  setup do
    @reflection = reflections(:one)
  end

  test "visiting the index" do
    visit reflections_url
    assert_selector "h1", text: "Reflections"
  end

  test "creating a Reflection" do
    visit reflections_url
    click_on "New Reflection"

    fill_in "Description", with: @reflection.description
    fill_in "User", with: @reflection.user_id
    click_on "Create Reflection"

    assert_text "Reflection was successfully created"
    click_on "Back"
  end

  test "updating a Reflection" do
    visit reflections_url
    click_on "Edit", match: :first

    fill_in "Description", with: @reflection.description
    fill_in "User", with: @reflection.user_id
    click_on "Update Reflection"

    assert_text "Reflection was successfully updated"
    click_on "Back"
  end

  test "destroying a Reflection" do
    visit reflections_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Reflection was successfully destroyed"
  end
end
