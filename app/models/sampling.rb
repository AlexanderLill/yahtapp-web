class Sampling < ApplicationRecord
  belongs_to :experience_sample_config

  # ensures that both value and sampled_at need to be provided at the same time
  validates_presence_of :value, if: :sampled_at?
  validates_presence_of :sampled_at, if: :value?

  validates_numericality_of :value, greater_than_or_equal_to: 1, less_than_or_equal_to: ->(sampling) { 1 + sampling.experience_sample_config.scale_steps }, only_integer: true, allow_nil: true

end
