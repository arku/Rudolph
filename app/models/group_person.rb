class GroupPerson < ActiveRecord::Base
  belongs_to :group
  belongs_to :person

  validates_presence_of :group, :person

  validates_uniqueness_of :person, scope: :group
end