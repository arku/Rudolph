require 'rails_helper'

describe GroupService do
  let(:group) { Group.find(1) }
  let(:current_person) { group.admin }
  subject { GroupService.new(group, current_person) }

  describe '#create_group' do

    context 'valid group' do
      let(:valid_params) {
        {
          :admin_id => "#{group.admin.id}",
          :name => "Test",
          :description => "Testing valid params",
          :location => "Here",
          :date => "2015-12-24 20:00:00",
          :price_range => "30-40"
        }
      }

      let(:response) { subject.create_group(valid_params) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a success feedback' do
        expect(response[:success]).to be true
      end

      it 'creates a new group' do
        expect{response}.to change{Group.count}.by(1)
      end
    end

    context 'invalid group' do
      let(:invalid_params) {
        {
          :admin_id => "#{group.admin.id}",
          :name => nil,
          :description => "Testing valid params",
          :location => "Here",
          :date => "12/24/2015",
          :price_range => "30-40"
        }
      }

      let(:response) { subject.create_group(invalid_params) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a failure feedback' do
        expect(response[:success]).to be false
      end

      it 'does not create a new group' do
        expect{response}.to_not change{Group.count}
      end
    end
  end

  describe '#update_group' do

    context 'valid params' do
      let(:valid_params) { {:name => "Updated Test"} }
      let(:response) { subject.update_group(valid_params) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a success feedback' do
        expect(response[:success]).to be true
      end

      it 'updates group information' do
        expect(group.name).to eq 'Updated Test'
      end
    end

    context 'invalid params' do
      let(:invalid_params) { {:name => nil} }
      let(:response) { subject.update_group(invalid_params) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a failure feedback' do
        expect(response[:success]).to be false
      end

      it 'does not update group information' do
         expect(group.name).to_not be_nil
      end
    end
  end

  describe '#remove_member' do

    let(:new_member) { Person.create(id: 200, email: 'new_person@itsrudolph.com', password: 'newperson') }

    before(:each) do
      GroupPerson.create(group: group, person: new_member)
    end

    context 'admin removes member' do
      let(:response) { subject.remove_member(new_member) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a success feedback' do
        expect(response[:success]).to be_truthy
      end

      it 'removes the member from the group' do
        expect{response}.to change{group.people.count}.by(-1)
        expect(group.people.include?(new_member)).to be false
      end
    end

    context 'member leaves group' do
      let(:current_person) { new_member }
      let(:response) { subject.remove_member(new_member) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a success feedback' do
        expect(response[:success]).to be_truthy
      end

      it 'removes the member from the group' do
        expect{response}.to change{group.people.count}.by(-1)
        expect(group.people.include?(new_member)).to be false
      end
    end

    context 'unauthorized user tries to remove member' do
      let(:current_person) { Person.find(2) }
      let(:response) { subject.remove_member(new_member) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a failure feedback' do
        expect(response[:success]).to be false
      end

      it 'does not remove the member from the group' do
        expect{response}.to_not change{group.people.count}
        expect(group.people.include?(new_member)).to be true
      end
    end

    context 'names have already been drawn' do
      before(:all) do
        group = Group.find(1)
        group.status = 1
        group.save
      end

      let(:response) { subject.remove_member(new_member) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a failure feedback' do
        expect(response[:success]).to be false
      end

      it 'does not remove the member from the group' do
        expect{response}.to_not change{group.people.count}
        expect(group.people.include?(new_member)).to be true
      end
    end
  end

  describe '#make_admin' do

    let(:new_admin) { Person.find(2) }

    before(:all) {
      group = Group.find(1)
      person = Person.find(2)
      group_person = GroupPerson.where(group: group, person: person).first
      group_person.update_attribute(:confirmed, true) 
    }

    context 'current person is admin' do
      let(:response) { subject.make_admin(new_admin.id) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a success feedback' do
        expect(response[:success]).to be true
      end

      it 'changes the group admin' do
        expect(group.admin).to eq(new_admin)
      end
    end

    context 'current person is not admin' do
      before(:all) do
        group = Group.find(1)
        group.admin = Person.find(1)
        group.save
      end

      let(:current_person) { Person.find(3) }
      let(:response) { subject.make_admin(new_admin.id) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a failure feedback' do
        expect(response[:success]).to be false
      end

      it 'does not change the group admin' do
        expect(group.admin.id).to eq(1)
      end
    end

    context 'member is not active' do
      before(:all) do
        group = Group.find(1)
        current_person = group.admin
        subject = GroupService.new(group, current_person)
        subject.send_invitations(['a@a.com'])
        group.reload
      end

      let(:response) do
        member = group.people.where(email: 'a@a.com').last
        subject.make_admin(member.id)
      end

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a failure feedback' do
        expect(response[:success]).to be false
      end

      it 'does not change the group admin' do
        expect(group.admin.id).to eq(1)
      end
    end

    context 'invalid member' do
      let(:response) { subject.make_admin(1234567890) }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a failure feedback' do
        expect(response[:success]).to be false
      end

      it 'does not change the group admin' do
        expect(group.admin.id).to eq(1)
      end
    end
  end

  describe '#send_invitations' do
  end

  describe '#accept_group' do
    before(:all) { Group.create(name: 'Invitations Test', date: Date.tomorrow, admin_id: 1) }

    let(:group) { Group.where(name: 'Invitations Test').first }

    context 'person was invited' do
      before(:all) do
        group = Group.where(name: 'Invitations Test').first
        GroupService.new(group, Person.find(1)).send_invitations(['daniel@itsrudolph.com'])
      end

      let(:invited_person) { Person.find(2) }
      let(:response) { GroupService.new(group, invited_person).accept_group }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a success feedback' do
        expect(response[:success]).to be true
      end

      it 'confirms the new member' do
        group_person = GroupPerson.where(group: group, person: invited_person).first
        expect(group_person.confirmed).to be true
      end

      it "changes new member's status to 'active'" do
        expect(invited_person.status(group)).to eq('active')
      end
    end

    context 'person was not invited' do
      let(:uninvited_person) { Person.find(13) }
      let(:response) { GroupService.new(group, uninvited_person).accept_group }

      it 'returns a hash' do
        expect(response).to be_a(Hash)
      end

      it 'returns a failure feedback' do
        expect(response[:success]).to be false
      end

      it 'does not confirm the new member' do
        group_person = GroupPerson.where(group: group, person: uninvited_person).first
        expect(group_person).to be_nil
      end

      it "does not change new member's status to 'active'" do
        expect(uninvited_person.status(group)).to_not eq('active')
      end
    end
  end
end