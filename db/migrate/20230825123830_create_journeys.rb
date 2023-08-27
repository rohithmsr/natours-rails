class CreateJourneys < ActiveRecord::Migration[6.1]
  def change
    create_table :journeys do |t|
      t.date :start_date
      t.date :end_date
      t.references :tour, null: false, foreign_key: true

      t.timestamps
    end
  end
end
