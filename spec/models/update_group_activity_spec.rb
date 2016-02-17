require 'rails_helper'

describe UpdateGroupActivity do

  let(:subject) { UpdateGroupActivity.create!(group_id: 1, person_id: 1) }

  describe '#description' do

    it 'returns the activity description' do
      expect(subject.description).to eq("Flora updated the group info.")
    end
  end

  describe '#full_description' do

    it 'returns the activity description including group name' do
      expect(subject.full_description).to eq("Flora updated 'School Friends' group info.")
    end
  end

end