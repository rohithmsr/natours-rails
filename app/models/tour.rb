class Tour < ApplicationRecord
  enum difficulty: {
    easy: 'easy',
    medium: 'medium',
    hard: 'hard'
  }

  validates :name, presence: true
  validates :rating, presence: true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5, message: 'must be from 0 to 5' }
  validates :duration, presence: true
  validates :difficulty, presence: true
end
