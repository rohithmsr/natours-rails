class Tour < ApplicationRecord
  DIFFICULTY_LEVELS = {
    easy: 'easy',
    medium: 'medium',
    hard: 'hard'
  }.freeze

  has_many :journeys, dependent: :destroy

  validates :name, presence: true
  validates :key, presence: true, uniqueness: true
  validates :difficulty, presence: true, inclusion: {
    in: DIFFICULTY_LEVELS.values,
    message: "must be one of #{DIFFICULTY_LEVELS.values.join(', ')}"
  }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price_discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
