require 'rails_helper'

describe DrawNamesActivity do

  let(:subject) { DrawNamesActivity.create!(group_id: 1, person_id: 1) }

  describe '#description' do

    it 'returns the activity description' do
      expect(subject.description).to eq("Names were finally drawn!")
    end
  end

  describe '#full_description' do

    it 'returns the activity description including group name' do
      expect(subject.full_description).to eq("Names were finally drawn in the group 'School Friends'!")
    end
  end

end