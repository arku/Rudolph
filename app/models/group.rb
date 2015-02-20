class Group < ActiveRecord::Base
  has_many :group_people
  has_many :people, through: :group_people
  has_many :exchanges

  belongs_to :admin, class_name: 'Person', foreign_key: 'admin_id'
end