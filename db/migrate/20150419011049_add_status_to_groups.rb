class AddStatusToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :status, :integer, default: 0, after: :price_range
  end
end
