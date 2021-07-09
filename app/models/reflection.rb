class Reflection < ApplicationRecord
  belongs_to :user
  has_many :habit_reflections, dependent: :destroy
  has_many :habits, through: :habit_reflections
  accepts_nested_attributes_for :habit_reflections
end
