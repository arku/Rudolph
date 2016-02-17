require 'rails_helper'

describe CreateGroupActivity do

  let(:subject) { CreateGroupActivity.create!(group_id: 1, person_id: 1) }

  describe '#description' do

    it 'returns the activity description' do
      expect(subject.description).to eq("Flora created the group.")
    end
  end

  describe '#full_description' do

    it 'returns the activity description including group name' do
      expect(subject.full_description).to eq("Flora created the group 'School Friends'.")
    end
  end

end