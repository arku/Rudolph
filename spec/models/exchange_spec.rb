require 'rails_helper'

describe Exchange do

  let(:valid_exchange) do
    Exchange.create!(group_id: 1, giver_id: 1, receiver_id: 2)
  end

  it 'has a group, a giver and a receiver' do
    expect(valid_exchange).to be_valid
  end

  it 'is invalid without a group' do
    exchange = Exchange.new(giver_id: 1, receiver_id: 2)
    expect(exchange).to_not be_valid
  end

  it 'is invalid without a giver' do
    exchange = Exchange.new(group_id: 1, receiver_id: 2)
    expect(exchange).to_not be_valid
  end

  it 'is invalid without a receiver' do
    exchange = Exchange.new(group_id: 1, giver_id: 1)
    expect(exchange).to_not be_valid
  end

  it 'cannot have a same giver more than once in the same group' do
    exchange = Exchange.new(group_id: 1, giver_id: 1, receiver_id: 3)
    expect(exchange).to_not be_valid
  end

  it 'cannot have a same receiver more than once in the same group' do
    exchange = Exchange.new(group_id: 1, giver_id: 3, receiver_id: 2)
    expect(exchange).to_not be_valid
  end

  it 'is invalid if giver and receiver are the same person' do
    exchange = Exchange.new(group_id: 1, giver_id: 1, receiver_id: 1)
    expect(exchange).to_not be_valid
  end

  it 'has a giver and a receiver from the same group' do
    exchange = Exchange.new(group_id: 1, giver_id: 7, receiver_id: 13)
    expect(exchange).to_not be_valid
  end

  it 'has a valid group' do
    exchange = Exchange.new(group_id: 1000000, giver_id: 1, receiver_id: 2)
    expect(exchange).to_not be_valid
  end

  it 'has a valid giver' do
    exchange = Exchange.new(group_id: 1, giver_id: 1000000, receiver_id: 2)
    expect(exchange).to_not be_valid
  end

  it 'has a valid receiver' do
    exchange = Exchange.new(group_id: 1, giver_id: 1, receiver_id: 1000000)
    expect(exchange).to_not be_valid
  end

end