class GroupActivity < ActiveRecord::Base
  belongs_to :group
  belongs_to :person

  default_scope { order('created_at DESC') }
  scope :by_person, ->(person) { where("group_id IN (?)", person.groups.pluck(:id)).order('created_at DESC').limit(6) }

  def error_messages
    errors.full_messages.join(', ')
  end
end