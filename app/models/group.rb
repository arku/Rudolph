class Group < ActiveRecord::Base
  has_many :group_people
  has_many :people, through: :group_people
  has_many :exchanges

  belongs_to :admin, class_name: 'Person', foreign_key: 'admin_id'

  validates_presence_of :admin, :name

  after_create :add_admin

  def add_admin
    add_person(admin)
  end

  def add_person(person)
    GroupPerson.create(group_id: id, person_id: person.id)
  end

  def can_draw_names?
    people.select{|person| person.status == 'pending'}.empty? && people.size > 1
  end

  def draw_pending?
    status == 0
  end

  def draw_done?
    status == 1
  end

end