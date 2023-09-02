class Order < ApplicationRecord
  enum travel_status: { upcoming: 'upcoming', completed: 'completed', cancelled: 'cancelled', absent: 'absent' }

  belongs_to :traveller
  belongs_to :journey

  validates :amount, presence: true
  validates :travel_status, presence: true
  validate :travel_status_for_unpaid

private

  def travel_status_for_unpaid
    return if payment_done
    return unless travel_status == 'completed'

    errors.add :travel_status, message: 'cannot be set to \'completed\' without payment'
  end
end
