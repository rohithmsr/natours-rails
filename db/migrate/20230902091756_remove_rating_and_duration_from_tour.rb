class RemoveRatingAndDurationFromTour < ActiveRecord::Migration[6.1]
  def change
    remove_column :tours, :rating, :float
    remove_column :tours, :duration, :integer
  end
end
