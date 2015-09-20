class NameDrawer

  attr_accessor :group, :people

  def initialize(group)
    @group  = group
    @people = group.people.shuffle
  end

  def perform
    if group.draw_pending?
      people.each_with_index do |person, index|
        receiver = last_person?(person) ? people.first : people[index + 1]
        create_exchange(person, receiver)
      end
      true
    end
  end

  def create_exchange(giver, receiver)
    Exchange.create!(group: group, giver: giver, receiver: receiver)
  end

  def last_person?(person)
    person == people.last
  end

end