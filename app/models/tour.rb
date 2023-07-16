class Tour < ApplicationRecord
  DIFFICULTY_LEVELS = {
    easy: 'easy',
    medium: 'medium',
    hard: 'hard'
  }.freeze

  validates :name, presence: true
  validates :key, presence: true, uniqueness: true
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :duration, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :difficulty, presence: true, inclusion: {
    in: DIFFICULTY_LEVELS.values,
    message: "must be one of #{DIFFICULTY_LEVELS.values.join(', ')}"
  }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price_discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
