class FixCharset < ActiveRecord::Migration
  def change
    %w( exchanges group_activities group_people groups messages people wishlist_items ).each do |latin1_table_with_char_columns|
      execute("ALTER TABLE #{latin1_table_with_char_columns} CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;")
    end
  end
end
