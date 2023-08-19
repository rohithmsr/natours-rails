class AddAvatarAndStatusToTravellers < ActiveRecord::Migration[6.1]
  def change
    add_column :travellers, :avatar, :string
    add_column :travellers, :status, :string
  end
end
