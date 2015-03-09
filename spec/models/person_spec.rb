require 'rails_helper'

describe Person do
  
  it 'has an email address and a password' do
    person = Person.new(email: 'flora.saramago@gmail.com', password:'password1')
    expect(person).to be_valid
  end

  it 'has a unique email address' do
    person = Person.new(email: 'flora@rudolph.com', password:'password1')
    expect(person).to_not be_valid
  end

  it 'is invalid without an email address' do
    person = Person.new(password:'password1')
    expect(person).to_not be_valid
  end

  it 'is invalid without a password' do
    person = Person.new(email: 'email@email.com')
    expect(person).to_not be_valid
  end

  it 'has a valid email address' do
    person = Person.new(email: 'flora', password:'password1')
    expect(person).to_not be_valid
  end

end