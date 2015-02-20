class Exchange < ActiveRecord::Base
  belongs_to :group
  belongs_to :giver,    class_name: 'Person', foreign_key: 'giver_id'
  belongs_to :receiver, class_name: 'Person', foreign_key: 'receiver_id'
end