class AddDetailsToTours < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :price, :decimal, precision: 5, scale: 2
    add_column :tours, :price_discount, :float, default: 0
    add_column :tours, :description, :text
  end
end
