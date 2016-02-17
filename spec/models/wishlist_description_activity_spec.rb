require 'rails_helper'

describe WishlistDescriptionActivity do

  let(:subject) { WishlistDescriptionActivity.create!(group_id: 1, person_id: 1) }

  describe '#description' do

    it 'returns the activity description' do
      expect(subject.description).to eq("Flora updated their wishlist description.")
    end
  end

  describe '#full_description' do

    it 'returns the activity description including group name' do
      expect(subject.full_description).to eq("Flora updated their wishlist description in the group 'School Friends'.")
    end
  end

end