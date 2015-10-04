class RudolphMailer < ActionMailer::Base

  default :from => "Rudolph <rudolph@itsrudolph.com>"

  def accept_group(person, group, invited_by)
    @person = person
    @group  = group
    @invited_by = invited_by

    mail :to => @person.email, :subject => t('invitation_subject', name: @group.name)
  end

  def names_drawn(person, group)
    @person = person
    @group  = group

    mail :to => @person.email, :subject => t('status_drawn')
  end
end