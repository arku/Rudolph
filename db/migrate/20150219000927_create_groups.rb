class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :admin_id
      t.string :name
      t.text :description
      t.datetime :date
      t.string :location
      t.string :price_range
    end
  end
end
