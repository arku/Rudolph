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

end