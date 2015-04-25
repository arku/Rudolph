require 'rails_helper'

describe Person do

  it 'has an email address and a password' do
    person = Person.new(email: 'flora.saramago@gmail.com', password: 'password1')
    expect(person).to be_valid
  end

  it 'has a unique email address' do
    person = Person.new(email: 'flora@rudolph.com', password: 'password1')
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
    person = Person.invite!(email: 'test_invitation@rudolph.com', invited_by_id: 1)
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

  it 'has a valid_status' do
    valid_statuses = ['pending', 'active']

    Person.all.each do |person|
      expect(valid_statuses).to include(person.status)
    end
  end

  it "is 'pending' when invitation was not accepted yet" do
    person = Person.invite!(email: 'new_test_invitation@rudolph.com', invited_by_id: 1)
    expect(person.status).to eq('pending')
  end

  it "is 'active' after they accept the invitation" do
    person = Person.find(15)
    expect(person.status).to eq('active')
  end

end