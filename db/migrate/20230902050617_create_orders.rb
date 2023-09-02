class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :traveller, null: false, foreign_key: true
      t.references :journey, null: false, foreign_key: true
      t.decimal :amount, precision: 5, scale: 2
      t.boolean :payment_done, null: false, default: false
      t.string :travel_status, default: 'upcoming'

      t.timestamps
    end
  end
end
