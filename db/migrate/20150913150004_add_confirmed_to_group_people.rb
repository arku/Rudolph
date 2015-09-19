class AddConfirmedToGroupPeople < ActiveRecord::Migration
  def change
    add_column :group_people, :confirmed, :boolean, after: :person_id
  end
end
