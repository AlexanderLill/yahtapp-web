require "test_helper"

class ExperienceSampleConfigsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @experience_sample_config = experience_sample_configs(:one)
  end

  test "should get index" do
    get experience_sample_configs_url
    assert_response :success
  end

  test "should get new" do
    get new_experience_sample_config_url
    assert_response :success
  end

  test "should create experience_sample_config" do
    assert_difference('ExperienceSampleConfig.count') do
      post experience_sample_configs_url, params: { experience_sample_config: { prompt: @experience_sample_config.prompt, scale_end: @experience_sample_config.scale_end, scale_label_center: @experience_sample_config.scale_label_center, scale_label_end: @experience_sample_config.scale_label_end, scale_label_start: @experience_sample_config.scale_label_start, scale_start: @experience_sample_config.scale_start, scale_steps: @experience_sample_config.scale_steps, schedule: @experience_sample_config.schedule, title: @experience_sample_config.title, user_id: @experience_sample_config.user_id } }
    end

    assert_redirected_to experience_sample_config_url(ExperienceSampleConfig.last)
  end

  test "should show experience_sample_config" do
    get experience_sample_config_url(@experience_sample_config)
    assert_response :success
  end

  test "should get edit" do
    get edit_experience_sample_config_url(@experience_sample_config)
    assert_response :success
  end

  test "should update experience_sample_config" do
    patch experience_sample_config_url(@experience_sample_config), params: { experience_sample_config: { prompt: @experience_sample_config.prompt, scale_end: @experience_sample_config.scale_end, scale_label_center: @experience_sample_config.scale_label_center, scale_label_end: @experience_sample_config.scale_label_end, scale_label_start: @experience_sample_config.scale_label_start, scale_start: @experience_sample_config.scale_start, scale_steps: @experience_sample_config.scale_steps, schedule: @experience_sample_config.schedule, title: @experience_sample_config.title, user_id: @experience_sample_config.user_id } }
    assert_redirected_to experience_sample_config_url(@experience_sample_config)
  end

  test "should destroy experience_sample_config" do
    assert_difference('ExperienceSampleConfig.count', -1) do
      delete experience_sample_config_url(@experience_sample_config)
    end

    assert_redirected_to experience_sample_configs_url
  end
end
