require 'rails_helper'

describe WishlistItemActivity do

  let(:item) { WishlistItem.create!(
      group_person_id: 1,
      name_or_url: "http://www.submarino.com.br/produto/119195941/cafeteira-expresso-nespresso-19-bar-ruby-red-inissia",
      link_title: "Cafeteira Expresso Nespresso 19 BAR Ruby Red Inissia - Submarino.com.br"
    )
  }

  let(:subject) { WishlistItemActivity.create!(group_id: 1, person_id: 1, resource_id: item.id) }

  describe '#description' do

    it 'returns the activity description' do
      expect(subject.description).to eq("Flora added \"Cafeteira Expresso Nespresso 19 BAR Ruby Red Inissia - Submarino.com.b...\" to their wishlist.")
    end
  end

  describe '#full_description' do

    it 'returns the activity description including group name' do
      expect(subject.full_description).to eq("Flora added \"Cafeteira Expresso Nespresso 19 BAR Ruby Red Inissia - Submarino.com.b...\" to their wishlist in the group 'School Friends'.")
    end
  end

end