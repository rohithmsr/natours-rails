class AddUniqueIndexToTravelAssignment < ActiveRecord::Migration[6.1]
  def change
    add_index :travel_assignments, [:traveller_id, :journey_id], unique: true
  end
end
