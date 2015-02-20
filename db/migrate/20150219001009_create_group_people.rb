class CreateGroupPeople < ActiveRecord::Migration
  def change
    create_table :group_people do |t|
      t.integer :group_id
      t.integer :person_id
    end
  end
end
