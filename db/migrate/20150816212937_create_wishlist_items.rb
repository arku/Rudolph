class CreateWishlistItems < ActiveRecord::Migration
  def change
    create_table :wishlist_items do |t|
      t.integer :group_person_id
      t.text :name_or_url
      t.text :comments
      t.string :image
      t.string :link_title
      t.text :link_description
    end
  end
end
