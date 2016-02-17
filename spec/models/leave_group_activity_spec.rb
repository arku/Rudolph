require 'rails_helper'

describe LeaveGroupActivity do

  let(:subject) { LeaveGroupActivity.create!(group_id: 1, person_id: 1) }

  describe '#description' do

    it 'returns the activity description' do
      expect(subject.description).to eq("Flora left the group. :(")
    end
  end

  describe '#full_description' do

    it 'returns the activity description including group name' do
      expect(subject.full_description).to eq("Flora left the group 'School Friends'. :(")
    end
  end

end