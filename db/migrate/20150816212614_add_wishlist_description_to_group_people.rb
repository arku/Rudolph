class AddWishlistDescriptionToGroupPeople < ActiveRecord::Migration
  def change
    add_column :group_people, :wishlist_description, :text, after: :person_id
  end
end
