class GroupService

  attr_accessor :group, :current_person

  def initialize(group, current_person)
    @group          = group
    @current_person = current_person
  end

  def create_group(params)
    begin
      @group = Group.create!(normalize(params))
      {success: true, message: "Successfully created group #{group.name}"}
    rescue => error
      {success: false, message: error.message}
    end
  end

  def update_group(params)
    begin
      @group.update!(params)
      {success: true, message: "Successfully updated group #{@group.name}"}
    rescue => error
      {success: false, message: error.message}
    end
  end

  def remove_member(member)
    if can_remove_member?(member) && group.draw_pending?
      {success: remove_group_person(member)}
    else
      {success: false}
    end
  end

  def make_admin(member_id)
    if current_person.is_admin?(group)
      begin
        group.admin = Person.find(member_id)
        group.save!
        {success: true, message: 'Admin updated successfully'}
      rescue => error
        {success: false, message: error.message}
      end
    else
      {success: false, message: 'Only the Admin can make someone else Admin'}
    end
  end

  def send_invitations(friends)
    errors = {}
    success = []

    friends.each do |email|
      person = Person.where(email: email).first

      if !person || person.can_be_invited?
        person = Person.invite!(email: email, invited_by_id: current_person.id)

        if person.valid?
          group_person = add_group_person(person)
          group_person.valid? ? success << email : errors[email] = group_person.error_messages
        else
          errors[email] = person.error_messages
        end
      end
    end

    {success_list: success, error_list: errors}
  end

  private

  def add_group_person(person)
    GroupPerson.create(group: group, person: person)
  end

  def remove_group_person(member)
    GroupPerson.where(group: group, person: member).first.try(:destroy)
  end

  def normalize(params)
    params[:date] = Date.strptime(params[:date], '%m/%d/%Y')
    params
  end

  def can_remove_member?(member)
    current_person.is_admin?(group) || current_person == member
  end
end