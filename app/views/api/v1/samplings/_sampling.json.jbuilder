json.id sampling.id
json.scheduled_at sampling.scheduled_at.nil? ? nil : sampling.scheduled_at.iso8601(3)
json.sampled_at sampling.sampled_at.nil? ? nil : sampling.sampled_at.iso8601(3)
json.value sampling.value

# Nested config
json.config do
  json.id  sampling.experience_sample_config.id
  json.title  sampling.experience_sample_config.title
  json.prompt  sampling.experience_sample_config.prompt
  json.type "scale"
  json.scale do
    json.steps sampling.experience_sample_config.scale_steps
    json.label_start  sampling.experience_sample_config.scale_label_start
    json.label_center  sampling.experience_sample_config.scale_label_center
    json.label_end  sampling.experience_sample_config.scale_label_end
  end
end