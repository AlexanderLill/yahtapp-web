class ExperienceSampleConfig < ApplicationRecord
  belongs_to :user
  has_many :samplings

  include Schedulable
  include_schedule :schedule

  validates :title, presence: true
  after_save :schedule_samplings # TODO: later this action must be performed when a habit is *duplicated* and on a daily schedule


  def schedule_samplings(starting_from = self.updated_at, retention_period = 7.days)

    Sampling.transaction do
      # 1. remove all samplings newer than current updated_at
      samplings.where("scheduled_at >= ?", starting_from).delete_all

      # 2. create new samplings newer than current updated_at
      dates = self.get_schedule(starting: starting_from, ending: (starting_from + retention_period).at_end_of_day)
      dates.each do |date|
        Sampling.create!(experience_sample_config_id: self.id, scheduled_at: date)
      end
    end
  end

end
