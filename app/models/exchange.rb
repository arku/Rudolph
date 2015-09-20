class Exchange < ActiveRecord::Base
  belongs_to :group
  belongs_to :giver,    class_name: 'Person', foreign_key: 'giver_id'
  belongs_to :receiver, class_name: 'Person', foreign_key: 'receiver_id'

  validates_presence_of :group, :giver, :receiver

  validates_uniqueness_of :giver, scope: :group
  validates_uniqueness_of :receiver, scope: :group

  validate :people_belong_to_same_group
  validate :giver_and_receiver_are_not_the_same

  def people_belong_to_same_group
    members = group.try(:people) || []

    unless members.include?(giver) && members.include?(receiver)
      errors.add(:receiver, "has to belong to same group as giver")
    end
  end

  def giver_and_receiver_are_not_the_same
    unless giver != receiver
      errors.add(:receiver, "can't be the same as giver")
    end
  end

end