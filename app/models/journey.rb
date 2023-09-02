class Journey < ApplicationRecord
  belongs_to :tour

  has_many :travel_assignments, dependent: :destroy
  has_many :travellers, through: :travel_assignments
  has_many :orders, dependent: :destroy

  validate :date_range_validity
  validates :start_date, presence: true
  validates :end_date, presence: true

private

  def date_range_validity
    return if start_date == end_date
    return if start_date.before?(end_date)

    errors.add :end_date, message: 'must be greater than or equal to start_date'
  end
end
