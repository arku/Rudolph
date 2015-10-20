class WishlistItemActivity < GroupActivity
  belongs_to :wishlist_item, foreign_key: 'resource_id'

  before_save :set_group_and_person

  def set_group_and_person
    self.group  = wishlist_item.group
    self.person = wishlist_item.person
  end

  def description
    I18n.t('wishlist_item_activity', person: person.first_name, item: item_name_short)
  end

  def full_description
    I18n.t('wishlist_item_activity_full', person: person.first_name, item: item_name_short, group: group.name)
  end

  private

  def item_name_short
    name = wishlist_item.name
    name.size <= 70 ? name : "#{name[0..69]}..."
  end
end