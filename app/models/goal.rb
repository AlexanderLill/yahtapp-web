class Goal < ApplicationRecord
  belongs_to :user
  has_many :derivatives, class_name: 'Goal', foreign_key: 'template_id'
  belongs_to :template, class_name: 'Goal', optional: true
  validates :title, presence: true
end
