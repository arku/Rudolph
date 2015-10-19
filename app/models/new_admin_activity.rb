class NewAdminActivity < GroupActivity

  def description
    I18n.t('new_admin_activity', person: person.first_name)
  end

  def full_description
    I18n.t('new_admin_activity_full', person: person.first_name, group: group.name)
  end

end