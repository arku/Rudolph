class CreateGroupActivity < ActiveRecord::Migration
  def change
    create_table :group_activities do |t|
      t.integer :group_id
      t.integer :person_id
      t.integer :resource_id
      t.string :type
      t.timestamps
    end
  end
end
