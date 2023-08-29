class TravelAssignment < ApplicationRecord
  belongs_to :traveller
  belongs_to :journey

  validates :traveller_id, uniqueness: { scope: :journey_id }
end
