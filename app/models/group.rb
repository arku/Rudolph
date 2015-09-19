class Group < ActiveRecord::Base
  has_many :group_people
  has_many :people, through: :group_people
  has_many :exchanges

  belongs_to :admin, class_name: 'Person', foreign_key: 'admin_id'

  validates_presence_of :admin, :name

  after_create :add_admin

  geocoded_by :location
  after_validation :geocode

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

  def update_status
    self.status = 1
    save
  end

  def show_location
    location.present? ? location : "That's still a mystery."
  end

  def show_price_range
    price_range.present? ? price_range : 'Anything goes!'
  end

  def show_description
    description.present? ? description : "#{admin.first_name} was too lazy to write a description for this group..."
  end

end