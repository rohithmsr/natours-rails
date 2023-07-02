class AddDifficultyToTours < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :difficulty, :string
  end
end
