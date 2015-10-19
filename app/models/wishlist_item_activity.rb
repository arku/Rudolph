class WishlistItemActivity < GroupActivity
  belongs_to :wishlist_item, foreign_key: 'resource_id'

  before_save :set_group_and_person

  def set_group_and_person
    self.group  = wishlist_item.group
    self.person = wishlist_item.person
  end

  def description
    I18n.t('wishlist_item_activity', person: person.first_name, item: wishlist_item.name)
  end

  def full_description
    I18n.t('wishlist_item_activity_full', person: person.first_name, item: wishlist_item.name, group: group.name)
  end
end