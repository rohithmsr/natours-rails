class CreateTravelAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :travel_assignments do |t|
      t.references :traveller, null: false, foreign_key: true
      t.references :journey, null: false, foreign_key: true

      t.timestamps
    end
  end
end
