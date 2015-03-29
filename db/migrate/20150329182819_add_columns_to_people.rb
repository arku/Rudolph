class AddColumnsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :provider, :string
    add_column :people, :uid, :string
    add_column :people, :name, :string
    add_column :people, :image, :string
    add_column :people, :token, :string
    add_column :people, :expires_at, :string
  end
end
