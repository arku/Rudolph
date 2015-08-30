class AddLatitudeAndLongitudeToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :latitude, :float, after: :status
    add_column :groups, :longitude, :float, after: :latitude
  end
end
