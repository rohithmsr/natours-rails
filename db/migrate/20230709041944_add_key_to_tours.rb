class AddKeyToTours < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :key, :string
    add_index :tours, :key, unique: true
  end
end
