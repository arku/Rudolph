class WishlistItem < ActiveRecord::Base
  belongs_to :group_person
  has_one :group, through: :group_person
  has_one :person, through: :group_person

  has_many :wishlist_item_activities

  def name
    is_url? && link_title ? link_title : name_or_url
  end

  def is_url?
    name_or_url.include?('http://') || name_or_url.include?('https://')
  end
end