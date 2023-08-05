class AddNamesToTravellers < ActiveRecord::Migration[6.1]
  def change
    add_column :travellers, :first_name, :string, null: false
    add_column :travellers, :last_name, :string, null: false
  end
end
