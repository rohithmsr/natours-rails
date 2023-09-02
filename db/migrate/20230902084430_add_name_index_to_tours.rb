class AddNameIndexToTours < ActiveRecord::Migration[6.1]
  def change
    add_index :tours, :name
  end
end
