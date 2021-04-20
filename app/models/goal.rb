class Goal < ApplicationRecord
  belongs_to :user
  has_many :derivatives, class_name: 'Goal', foreign_key: 'template_id'
  belongs_to :template, class_name: 'Goal', optional: true
  validates :title, presence: true
  enum color: { gray: 0, red: 1, yellow: 2, green: 3, blue: 4, indigo: 5, purple: 6, pink: 7 }
end
