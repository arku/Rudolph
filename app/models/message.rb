class Message < ActiveRecord::Base
  belongs_to :sender,   class_name: 'Person', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'Person', foreign_key: 'recipient_id'
  belongs_to :group

  scope :public_by_group, ->(group_id) { where(group_id: group_id, recipient_id: nil) }
end