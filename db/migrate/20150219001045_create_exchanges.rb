class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.integer :group_id
      t.integer :giver_id
      t.integer :receiver_id
    end
  end
end
