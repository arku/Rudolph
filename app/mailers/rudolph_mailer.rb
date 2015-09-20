class RudolphMailer < ActionMailer::Base

  default :from => "Rudolph <rudolph@itsrudolph.com>"

  def accept_group(person, group, invited_by)
    @person = person
    @group  = group
    @invited_by = invited_by

    mail :to => @person.email, :subject => "You've been invited to the group #{@group.name}"
  end

  def names_drawn(person, group)
    @person = person
    @group  = group

    mail :to => @person.email, :subject => "Names have been drawn!"
  end
end