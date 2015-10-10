require 'rails_helper'

describe Person do

  it 'has an email address and a password' do
    person = Person.new(email: 'flora.saramago@gmail.com', password: 'password1')
    expect(person).to be_valid
  end

  it 'has a unique email address' do
    person = Person.new(email: 'flora@itsrudolph.com', password: 'password1')
    expect(person).to_not be_valid
  end

  it 'is invalid without an email address' do
    person = Person.new(password: 'password1')
    expect(person).to_not be_valid
  end

  it 'is invalid without a password' do
    person = Person.new(email: 'email@email.com')
    expect(person).to_not be_valid
  end

  it 'has a valid email address' do
    person = Person.new(email: 'flora', password: 'password1')
    expect(person).to_not be_valid
  end

  it 'is invited when invitation was sent, but not accepted yet' do
    person = Person.invite!(email: 'test_invitation@itsrudolph.com', invited_by_id: 1)
    expect(person.invited?).to eq(true)
  end

  it 'is not considered invited after invitation is accepted' do
    person = Person.find(15)
    expect(person.invited?).to be_falsey
  end

  it 'always has a photo' do
    Person.all.each do |person|
      expect(person.photo_by_size('normal')).to_not be_nil
    end
  end

  it 'has a valid status for a group' do
    valid_statuses = ['pending', 'active']
    group = Group.find(1)

    Person.all.each do |person|
      expect(valid_statuses).to include(person.status(group))
    end
  end

  it "is 'pending' when invitation was not accepted yet" do
    person = Person.invite!(email: 'new_test_invitation@itsrudolph.com', invited_by_id: 1)
    group = Group.find(1)
    GroupPerson.create(group: group, person: person)

    expect(person.status(group)).to eq('pending')
  end

  it "is 'active' after they accept the invitation" do
    person = Person.find(1)
    group = Group.find(1)

    expect(person.status(group)).to eq('active')
  end

  describe '#error_messages' do
    it 'returns the error message' do
      person = Person.create(email: 'flora123@itsrudolph.com')
      expect(person.error_messages).to eq("Password can't be blank")
    end

    it 'concatenates messages' do
      person = Person.create()
      expect(person.error_messages).to eq("Email can't be blank, Password can't be blank")
    end
  end

  describe '#is_admin?' do
    context 'is admin' do
      it 'returns true' do
        person = Person.find(1)
        group = Group.find(1)

        expect(person.is_admin?(group)).to be true
      end
    end

    context 'is not admin' do
      it 'returns false' do
        person = Person.find(2)
        group = Group.find(1)

        expect(person.is_admin?(group)).to be false
      end
    end
  end

  describe '#is_member?' do
    context 'is member' do
      it 'returns true' do
        person = Person.find(1)
        group = Group.find(1)

        expect(person.is_member?(group)).to be true
      end
    end

    context 'is not member' do
      it 'returns false' do
        person = Person.create(email: 'not_in_group@itsrudolph.com', password: 'notingroup')
        group = Group.find(1)

        expect(person.is_member?(group)).to be false
      end
    end
  end

  describe '#wishlist_description' do
    it 'returns the correct description' do
      person = Person.find(1)
      group = Group.find(1)
      group_person = GroupPerson.where(person: person, group: group).first
      group_person.update_attribute(:wishlist_description, 'Some description')

      expect(person.wishlist_description(group)).to eq('Some description')
    end
  end

end