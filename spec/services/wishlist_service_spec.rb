require 'rails_helper'

describe WishlistService do
  let(:group) { Group.find(1) }
  let(:current_person) { group.admin }
  subject { WishlistService.new(group, current_person) }

  describe '#update' do

    context 'updating only description' do
      let(:response) { subject.update("My new description.", []) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a success feedback' do
        expect(response[:success]).to be true
      end

      it 'updates wishlist description' do
        expect(subject.group_person.wishlist_description).to eq("My new description.")
      end

      it 'does not add any items to the wishlist' do
        expect{response}.to_not change{subject.group_person.wishlist_items.count}
      end
    end

    context 'updating only items' do
      let(:items) {
        [
          {name_or_url: "http://www.americanas.com.br/produto/119195941/cafeteira-expresso-nespresso-19-bar-ruby-red-inissia", comments: 'I love coffee'},
          {name_or_url: 'Any coffee maker', comments: 'I really love coffee'},
          {name_or_url: 'A mug for my coffee', comments: ''}
        ]
      }
      let(:response) { subject.update(subject.group_person.wishlist_description, items) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a success feedback' do
        expect(response[:success]).to be true
      end

      it 'adds three items to wishlist' do
        expect{response}.to change{subject.group_person.wishlist_items.count}.by(3)
      end

      it 'does not change wishlist description' do
        expect{response}.to_not change{subject.group_person.wishlist_description}
      end
    end

    context 'updating both description and items' do
      let(:items) {
        [
          {name_or_url: "http://www.americanas.com.br/produto/119195941/cafeteira-expresso-nespresso-19-bar-ruby-red-inissia", comments: 'I love coffee'},
          {name_or_url: 'Any coffee maker', comments: 'I really love coffee'},
          {name_or_url: 'A mug for my coffee', comments: ''}
        ]
      }
      let(:response) { subject.update("A brand new description", items) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a success feedback' do
        expect(response[:success]).to be true
      end

      it 'updates wishlist description' do
        expect(subject.group_person.wishlist_description).to eq("A brand new description")
      end

      it 'adds three items to wishlist' do
        expect{response}.to change{subject.group_person.wishlist_items.count}.by(3)
      end
    end
  end

  describe '#update_description' do

    context 'valid description' do
      let(:response) { subject.update_description("My new description.") }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a success feedback' do
        expect(response[:success]).to be true
      end

      it 'updates wishlist description' do
        expect(subject.group_person.wishlist_description).to eq("My new description.")
      end
    end

    context 'invalid description' do
      before(:all) do
        group = Group.find(1)
        current_person = group.admin
        subject = WishlistService.new(group, current_person)
        subject.update_description("My new description.")
      end
      let(:response) { subject.update_description("#{21850.times.map {'a'}}") }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a failure feedback' do
        expect(response[:success]).to be false
      end

      it 'does not update wishlist description' do
        expect(subject.group_person.wishlist_description).to eq("My new description.")
      end
    end

  end

  describe '#update_list' do

    context 'one valid link item' do
      let(:item) { [{name_or_url: "http://www.americanas.com.br/produto/119195941/cafeteira-expresso-nespresso-19-bar-ruby-red-inissia", comments: 'I love coffee'}] }
      let(:response) { subject.update_list(item)}

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a success feedback' do
        expect(response[:success]).to be true
      end

      it 'adds an item to wishlist' do
        expect{response}.to change{subject.group_person.wishlist_items.count}.by(1)
      end

      it 'gets data from link' do
        item = subject.group_person.wishlist_items.last
        expect(item.image).to_not be_nil
        expect(item.link_title).to_not be_nil
        expect(item.link_description).to_not be_nil
      end
    end

    context 'one valid non-link item' do
      let(:item) { [{name_or_url: 'Any coffee maker', comments: 'I really love coffee'}] }
      let(:response) { subject.update_list(item)}

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a success feedback' do
        expect(response[:success]).to be true
      end

      it 'adds an item to wishlist' do
        expect{response}.to change{subject.group_person.wishlist_items.count}.by(1)
      end

      it 'does not get link data' do
        item = subject.group_person.wishlist_items.last
        expect(item.image).to be_nil
        expect(item.link_title).to be_nil
        expect(item.link_description).to be_nil
      end
    end

    context 'one invalid link item' do
      let(:item) { [{name_or_url: 'http://aaaaa', comments: 'Oops'}] }
      let(:response) { subject.update_list(item)}

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a failure feedback' do
        expect(response[:success]).to be false
      end

      it 'does not add an item to wishlist' do
        expect{response}.to_not change{subject.group_person.wishlist_items.count}
      end

      it 'does not get link data' do
        item = subject.group_person.wishlist_items.last
        expect(item.image).to be_nil
        expect(item.link_title).to be_nil
        expect(item.link_description).to be_nil
      end
    end

    context 'one invalid non-link item' do
      let(:item) { [{name_or_url: "#{21850.times.map {'a'}}", comments: 'Oops'}] }
      let(:response) { subject.update_list(item)}

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a failure feedback' do
        expect(response[:success]).to be false
      end

      it 'does not add an item to wishlist' do
        expect{response}.to_not change{subject.group_person.wishlist_items.count}
      end

      it 'does not get link data' do
        item = subject.group_person.wishlist_items.last
        expect(item.image).to be_nil
        expect(item.link_title).to be_nil
        expect(item.link_description).to be_nil
      end
    end

    context 'many valid items' do
      let(:items) {
        [
          {name_or_url: "http://www.americanas.com.br/produto/119195941/cafeteira-expresso-nespresso-19-bar-ruby-red-inissia", comments: 'I love coffee'},
          {name_or_url: 'Any coffee maker', comments: 'I really love coffee'},
          {name_or_url: 'A mug for my coffee', comments: ''}
        ]
      }
      let(:response) { subject.update_list(items)}

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a success feedback' do
        expect(response[:success]).to be true
      end

      it 'adds three items to wishlist' do
        expect{response}.to change{subject.group_person.wishlist_items.count}.by(3)
      end
    end

    context 'many items, some valid' do
      let(:items) {
        [
          {name_or_url: "http://www.americanas.com.br/produto/119195941/cafeteira-expresso-nespresso-19-bar-ruby-red-inissia", comments: 'I love coffee'},
          {name_or_url: 'Any coffee maker', comments: 'I really love coffee'},
          {name_or_url: "#{21850.times.map {'a'}}", comments: 'Oops'}
        ]
      }
      let(:response) { subject.update_list(items)}

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a failure feedback' do
        expect(response[:success]).to be false
      end

      it 'adds two items to wishlist' do
        expect{response}.to change{subject.group_person.wishlist_items.count}.by(2)
      end
    end

  end

end