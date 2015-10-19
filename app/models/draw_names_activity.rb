class DrawNamesActivity < GroupActivity

  def description
    I18n.t('draw_names_activity')
  end

  def full_description
    I18n.t('draw_names_activity_full', person: person.first_name, group: group.name)
  end

end