require File.join(Rails.root, 'app/business/name_drawer')

class GroupService

  attr_accessor :group, :current_person

  def initialize(group, current_person)
    @group          = group
    @current_person = current_person
  end

  def create_group(params)
    begin
      @group = Group.create!(params)
      CreateGroupActivity.create!(person: current_person, group: @group)
      { success: true, message: I18n.t('created_group', name: group.name) }
    rescue => error
      { success: false, message: error.message }
    end
  end

  def update_group(params)
    begin
      @group.update!(params)
      UpdateGroupActivity.create!(person: current_person, group: @group)
      { success: true, message: I18n.t('updated_group', name: group.name) }
    rescue => error
      { success: false, message: error.message }
    end
  end

  def remove_member(member)
    if can_remove_member?(member) && group.draw_pending?
      remove_group_person(member)
      LeaveGroupActivity.create!(person: member, group: group)
      { success: true }
    else
      { success: false }
    end
  end

  def make_admin(member_id)
    if current_person.is_admin?(group)
      begin
        member = Person.find(member_id)
        if member.status(group) == 'active'
          group.admin = member
          group.save!
          NewAdminActivity.create!(person: group.admin, group: group)
          { success: true, message: I18n.t('updated_admin') }
        else
          { success: false, message: I18n.t('inactive_admin') }
        end
      rescue => error
        { success: false, message: error.message }
      end
    else
      { success: false, message: I18n.t('only_admin') }
    end
  end

  def send_invitations(friends)
    errors = {}
    success = []

    friends.each do |email|
      begin
        person = Person.where(email: email).first

        if (!person || person.can_be_invited?) && !success.include?(email) && !errors.keys.include?(email)
          person = Person.invite!({email:email}, current_person)

          if person.valid?
            group_person = add_group_person(person)
            group_person.valid? ? success << email : errors[email] = group_person.error_messages
          else
            errors[email] = person.error_messages
          end
        end
      rescue => error
        puts error.message
      end
    end

    { success_list: success, error_list: errors }
  end

  def accept_group
    begin
      group_person = GroupPerson.where(group: group, person: current_person).first
      group_person.update_attribute(:confirmed, true)
      JoinGroupActivity.where(person: current_person, group: group).first_or_create!
      { success: true, message: I18n.t('welcome_to_group', name: group.name) }
    rescue => error
      { success: false, message: I18n.t('no_invitation') }
    end
  end

  def draw_names
    begin
      return { success: false, message: I18n.t('names_already_drawn') } unless group.draw_pending?
      return { success: false, message: I18n.t('only_admin_draw') } unless current_person.is_admin?(group)
      
      NameDrawer.new(group).perform
      group.update_status
      notify_members_after_draw
      DrawNamesActivity.create(person: current_person, group: group)
      
      { success: true }
    rescue => error
      { success: false, message: error.message }
    end
  end

  private

  def add_group_person(person)
    if group_person = GroupPerson.create(group: group, person: person, confirmed: person.invited?)
      RudolphMailer.accept_group(person, group, current_person).deliver_now
      group_person
    end
  end

  def remove_group_person(member)
    GroupPerson.where(group: group, person: member).first.try(:destroy!)
  end

  def can_remove_member?(member)
    current_person.is_admin?(group) || current_person == member
  end

  def notify_members_after_draw
    group.people.each do |person|
      RudolphMailer.names_drawn(person, group).deliver_now
    end
  end
end