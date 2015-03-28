class AddTimestamps < ActiveRecord::Migration
  def change
    change_table(:exchanges) { |t| t.timestamps }
    change_table(:group_people) { |t| t.timestamps }
    change_table(:groups) { |t| t.timestamps }
  end
end
