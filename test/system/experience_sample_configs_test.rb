require "application_system_test_case"

class ExperienceSampleConfigsTest < ApplicationSystemTestCase
  setup do
    @experience_sample_config = experience_sample_configs(:one)
  end

  test "visiting the index" do
    visit experience_sample_configs_url
    assert_selector "h1", text: "Experience Sample Configs"
  end

  test "creating a Experience sample config" do
    visit experience_sample_configs_url
    click_on "New Experience Sample Config"

    fill_in "Prompt", with: @experience_sample_config.prompt
    fill_in "Scale end", with: @experience_sample_config.scale_end
    fill_in "Scale label center", with: @experience_sample_config.scale_label_center
    fill_in "Scale label end", with: @experience_sample_config.scale_label_end
    fill_in "Scale label start", with: @experience_sample_config.scale_label_start
    fill_in "Scale start", with: @experience_sample_config.scale_start
    fill_in "Scale steps", with: @experience_sample_config.scale_steps
    fill_in "Schedule", with: @experience_sample_config.schedule
    fill_in "Title", with: @experience_sample_config.title
    fill_in "User", with: @experience_sample_config.user_id
    click_on "Create Experience sample config"

    assert_text "Experience sample config was successfully created"
    click_on "Back"
  end

  test "updating a Experience sample config" do
    visit experience_sample_configs_url
    click_on "Edit", match: :first

    fill_in "Prompt", with: @experience_sample_config.prompt
    fill_in "Scale end", with: @experience_sample_config.scale_end
    fill_in "Scale label center", with: @experience_sample_config.scale_label_center
    fill_in "Scale label end", with: @experience_sample_config.scale_label_end
    fill_in "Scale label start", with: @experience_sample_config.scale_label_start
    fill_in "Scale start", with: @experience_sample_config.scale_start
    fill_in "Scale steps", with: @experience_sample_config.scale_steps
    fill_in "Schedule", with: @experience_sample_config.schedule
    fill_in "Title", with: @experience_sample_config.title
    fill_in "User", with: @experience_sample_config.user_id
    click_on "Update Experience sample config"

    assert_text "Experience sample config was successfully updated"
    click_on "Back"
  end

  test "destroying a Experience sample config" do
    visit experience_sample_configs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Experience sample config was successfully destroyed"
  end
end
