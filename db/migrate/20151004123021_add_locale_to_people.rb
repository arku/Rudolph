class AddLocaleToPeople < ActiveRecord::Migration
  def change
    add_column :people, :locale, :string
  end
end
