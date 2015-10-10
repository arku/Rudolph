require 'rails_helper'

describe GroupPerson do

  it 'has a group and a person' do
    group = Group.find(2)
    person = Person.find(10)
    group_person = GroupPerson.create(group_id: 2, person_id: 10)

    expect(group_person).to be_valid
    expect(person.is_member?(group)).to eq(true)
  end

  it 'is not valid without a group' do
    group_person = GroupPerson.new(person_id: 1)
    expect(group_person).to_not be_valid
  end

  it 'is not valid without a person' do
    group_person = GroupPerson.new(group_id: 1)
    expect(group_person).to_not be_valid
  end

  it 'cannot include the same person twice in a group' do
    group_person = GroupPerson.new(group_id: 1, person_id: 1)
    expect(group_person).to_not be_valid
  end

  describe '#error_messages' do
    it 'returns the error message' do
      group_person = GroupPerson.create(group_id: 1, person_id: 2000000)
      expect(group_person.error_messages).to eq("Person can't be blank")
    end

    it 'concatenates messages' do
      group_person = GroupPerson.create(group_id: 1000000, person_id: 2000000)
      expect(group_person.error_messages).to eq("Group can't be blank, Person can't be blank")
    end
  end

end