class UpdateGroupActivity < GroupActivity

  def description
    I18n.t('update_group_activity', person: person.first_name)
  end

  def full_description
    I18n.t('update_group_activity_full', person: person.first_name, group: group.name)
  end

end