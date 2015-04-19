require 'rails_helper'

describe Group do

  it 'has a name and a group admin' do
    group = Group.new(name: 'Group1', admin_id: 1)
    expect(group).to be_valid
  end

  it 'is invalid without a name' do
    group = Group.new(admin_id: 1)
    expect(group).to_not be_valid
  end

  it 'is invalid without a group admin' do
    group = Group.new(name: 'Group1')
    expect(group).to_not be_valid
  end

  it 'has a valid group admin' do
    group = Group.new(name: 'Group1', admin_id: 100000000)
    expect(group).to_not be_valid
  end

  it 'always includes the admin in the group' do
    group = Group.create(name: 'Group1', admin_id: 1)
    admin = Person.find(1)
    expect(group.people).to include(admin)
    expect(admin.is_admin?(group)).to eq(true)
    expect(admin.is_member?(group)).to eq(true)
  end

  it 'cannot draw names when there are members pending confirmation' do
    group = Group.create(name: 'Pending', admin_id: 1)
    pending_person = Person.find(14)
    GroupPerson.create(group:group, person: pending_person)

    expect(group.can_draw_names?).to eq(false)
  end

  it 'can draw names after every member is confirmed' do
    group = Group.create(name: 'Ready', admin_id: 1)
    confirmed_person = Person.find(2)
    GroupPerson.create(group:group, person: confirmed_person)

    expect(group.can_draw_names?).to eq(true)
  end

  it "has a default status 0 (draw pending)" do
    group = Group.create(name: 'New', admin_id: 1)

    expect(group.status).to eq(0)
    expect(group.draw_pending?).to eq(true)
    expect(group.draw_done?).to eq(false)
  end

end