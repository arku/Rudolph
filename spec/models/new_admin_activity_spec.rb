require 'rails_helper'

describe NewAdminActivity do

  let(:subject) { NewAdminActivity.create!(group_id: 1, person_id: 1) }

  describe '#description' do

    it 'returns the activity description' do
      expect(subject.description).to eq("Flora is the new group admin.")
    end
  end

  describe '#full_description' do

    it 'returns the activity description including group name' do
      expect(subject.full_description).to eq("Flora is the new group admin in 'School Friends'.")
    end
  end

end