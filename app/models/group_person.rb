class GroupPerson < ActiveRecord::Base
  belongs_to :group
  belongs_to :person

  has_many :wishlist_items

  validates_presence_of :group, :person

  validates_uniqueness_of :person, scope: :group, message: "already belongs to this group"

  def error_messages
    errors.full_messages.join(' ,')
  end
end