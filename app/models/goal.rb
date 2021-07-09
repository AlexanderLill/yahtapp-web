class Goal < ApplicationRecord
  belongs_to :user
  has_many :derivatives, class_name: 'Goal', foreign_key: 'template_id'
  has_many :experience_sample_configs
  has_many :habits
  belongs_to :template, class_name: 'Goal', optional: true
  validates :title, presence: true
  validates :is_template, inclusion: [false], if: :template_id? # cannot be template if associated with template
  validates :template_id, absence: true, if: :is_template? # must not have association to template if is_template

  enum color: { gray: 0, red: 1, yellow: 2, green: 3, blue: 4, indigo: 5, purple: 6, pink: 7 }

  def clone(user)
    unless self.is_template?
      raise "Only templates can be duplicated."
    end

    new_goal = self.dup
    new_goal.is_template = false
    new_goal.template_id = self.id
    new_goal.user = user
    new_goal.save!

    new_goal
  end

end
