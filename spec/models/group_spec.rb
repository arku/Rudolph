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
    person = Person.find(2)
    GroupPerson.create(group:group, person: person)
    GroupService.new(group, person).accept_group

    expect(group.can_draw_names?).to eq(true)
  end

  it "has a default status 0 (draw pending)" do
    group = Group.create(name: 'New', admin_id: 1)

    expect(group.status).to eq(0)
    expect(group.draw_pending?).to eq(true)
    expect(group.draw_done?).to eq(false)
  end

  describe '#show_location' do
    context 'group has a location' do
      it 'returns the location' do
        group = Group.new(name: 'Group with Location', admin_id: 1, location: 'Some location')

        expect(group.show_location).to eq('Some location')
      end
    end

    context "group doesn't have a location" do
      it 'returns a placeholder' do
        group = Group.new(name: 'Group without Location', admin_id: 1)

        expect(group.show_location).to eq("That's still a mystery.")
      end
    end
  end

  describe '#show_price_range' do
    context 'group has a price range' do
      it 'returns the price range' do
        group = Group.new(name: 'Group with Price Range', admin_id: 1, price_range: '100-200')

        expect(group.show_price_range).to eq('100-200')
      end
    end

    context "group doesn't have a price range" do
      it 'returns a placeholder' do
        group = Group.new(name: 'Group without Price Range', admin_id: 1)

        expect(group.show_price_range).to eq('Anything goes!')
      end
    end
  end

  describe '#show_description' do
    context 'group has a description' do
      it 'returns the description' do
        group = Group.new(name: 'Group with Description', admin_id: 1, description: 'Some description')

        expect(group.show_description).to eq('Some description')
      end
    end

    context "group doesn't have a description" do
      it 'returns a placeholder' do
        group = Group.new(name: 'Group without Description', admin_id: 1)

        expect(group.show_description).to eq('Flora was too lazy to write a description for this group...')
      end
    end
  end

end