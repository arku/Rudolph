require 'rails_helper'
require 'ostruct'

describe Person do

  it 'has an email address and a password' do
    person = Person.new(email: 'flora.saramago@gmail.com', password: 'password1')
    expect(person).to be_valid
  end

  it 'has a unique email address' do
    person = Person.new(email: 'flora@itsrudolph.com', password: 'password1')
    expect(person).to_not be_valid
  end

  it 'is invalid without an email address' do
    person = Person.new(password: 'password1')
    expect(person).to_not be_valid
  end

  it 'is invalid without a password' do
    person = Person.new(email: 'email@email.com')
    expect(person).to_not be_valid
  end

  it 'has a valid email address' do
    person = Person.new(email: 'flora', password: 'password1')
    expect(person).to_not be_valid
  end

  it 'is invited when invitation was sent, but not accepted yet' do
    person = Person.invite!(email: 'test_invitation@itsrudolph.com', invited_by_id: 1)
    expect(person.invited?).to eq(true)
  end

  it 'is not considered invited after invitation is accepted' do
    person = Person.find(15)
    expect(person.invited?).to be_falsey
  end

  it 'always has a photo' do
    Person.all.each do |person|
      expect(person.photo_by_size('normal')).to_not be_nil
    end
  end

  it 'has a valid status for a group' do
    valid_statuses = ['pending', 'active']
    group = Group.find(1)

    Person.all.each do |person|
      expect(valid_statuses).to include(person.status(group))
    end
  end

  it "is 'pending' when invitation was not accepted yet" do
    person = Person.invite!(email: 'new_test_invitation@itsrudolph.com', invited_by_id: 1)
    group = Group.find(1)
    GroupPerson.create(group: group, person: person)

    expect(person.status(group)).to eq('pending')
  end

  it "is 'active' after they accept the invitation" do
    person = Person.find(1)
    group = Group.find(1)

    expect(person.status(group)).to eq('active')
  end

  describe '#error_messages' do
    it 'returns the error message' do
      person = Person.create(email: 'flora123@itsrudolph.com')
      expect(person.error_messages).to eq("Password can't be blank")
    end

    it 'concatenates messages' do
      person = Person.create()
      expect(person.error_messages).to eq("Email can't be blank, Password can't be blank")
    end
  end

  describe '#is_admin?' do
    context 'is admin' do
      it 'returns true' do
        person = Person.find(1)
        group = Group.find(1)

        expect(person.is_admin?(group)).to be true
      end
    end

    context 'is not admin' do
      it 'returns false' do
        person = Person.find(2)
        group = Group.find(1)

        expect(person.is_admin?(group)).to be false
      end
    end
  end

  describe '#is_member?' do
    context 'is member' do
      it 'returns true' do
        person = Person.find(1)
        group = Group.find(1)

        expect(person.is_member?(group)).to be true
      end
    end

    context 'is not member' do
      it 'returns false' do
        person = Person.create(email: 'not_in_group@itsrudolph.com', password: 'notingroup')
        group = Group.find(1)

        expect(person.is_member?(group)).to be false
      end
    end
  end

  describe '#omniauth' do
    before(:all) do
      auth = OpenStruct.new({
        "provider"=>"facebook",
        "uid"=>"1234",
        "info"=>
         OpenStruct.new({"email"=>"flora.saramago@gmail.com",
          "name"=>"Flora Saramago",
          "first_name"=>"Flora",
          "last_name"=>"Saramago",
          "image"=>"http://graph.facebook.com/1234/picture",
          "urls"=>OpenStruct.new({"Facebook"=>"https://www.facebook.com/app_scoped_user_id/1234/"}),
          "verified"=>true}),
        "credentials"=>
         OpenStruct.new({"token"=>"some_token", "expires_at"=>1456840138, "expires"=>true}),
        "extra"=>
         OpenStruct.new({"raw_info"=>
           OpenStruct.new({"id"=>"1234",
            "email"=>"flora.saramago@gmail.com",
            "first_name"=>"Flora",
            "gender"=>"female",
            "last_name"=>"Saramago",
            "link"=>"https://www.facebook.com/app_scoped_user_id/1234/",
            "locale"=>"en_GB",
            "name"=>"Flora Saramago",
            "timezone"=>-2,
            "updated_time"=>"2015-10-13T11:36:38+0000",
            "verified"=>true
          })
        })
      })
      Person.omniauth(auth)
    end

    let(:person) { person = Person.where(uid: '1234').first }

    it 'sets user data' do
      expect(person.name).to eq('Flora Saramago')
      expect(person.email).to eq('flora.saramago@gmail.com')
      expect(person.token).to eq('some_token')
    end
  end

  describe '#apply_omniauth' do
    before(:all) do
      person = Person.create(id: 12345600, name: 'Old Name', email: 'a@a.com', password: 'password1')

      auth = OpenStruct.new({
        "provider"=>"facebook",
        "uid"=>"12345",
        "info"=>
         OpenStruct.new({"email"=>"flora.saramago2@gmail.com",
          "name"=>"Flora Saramago",
          "first_name"=>"Flora",
          "last_name"=>"Saramago",
          "image"=>"http://graph.facebook.com/12345/picture",
          "urls"=>OpenStruct.new({"Facebook"=>"https://www.facebook.com/app_scoped_user_id/12345/"}),
          "verified"=>true}),
        "credentials"=>
         OpenStruct.new({"token"=>"some_token", "expires_at"=>1456840138, "expires"=>true}),
        "extra"=>
         OpenStruct.new({"raw_info"=>
           OpenStruct.new({"id"=>"12345",
            "email"=>"flora.saramago@gmail.com",
            "first_name"=>"Flora",
            "gender"=>"female",
            "last_name"=>"Saramago",
            "link"=>"https://www.facebook.com/app_scoped_user_id/12345/",
            "locale"=>"en_GB",
            "name"=>"Flora Saramago",
            "timezone"=>-2,
            "updated_time"=>"2015-10-13T11:36:38+0000",
            "verified"=>true
          })
        })
      })

      person.apply_omniauth(auth)
    end

    let(:person) { person = Person.find(12345600) }

    it 'sets user data' do
      expect(person.name).to eq('Flora Saramago')
      expect(person.email).to eq('flora.saramago2@gmail.com')
      expect(person.token).to eq('some_token')
      expect(person.provider).to eq('facebook')
      expect(person.uid).to eq('12345')
    end
  end

  describe '#is_admin_of' do
    let(:person) { Person.find(1) }

    it 'returns the correct groups' do
      groups = person.is_admin_of
      expect(groups).to include(Group.find(1))
      expect(groups).to include(Group.find(2))
    end
  end

  describe '#wishlist_description' do
    it 'returns the correct description' do
      person = Person.find(1)
      group = Group.find(1)
      group_person = GroupPerson.where(person: person, group: group).first
      group_person.update_attribute(:wishlist_description, 'Some description')

      expect(person.wishlist_description(group)).to eq('Some description')
    end
  end

  describe '#wishlist_items' do
    before(:all) do
      person = Person.find(1)
      group  = Group.find(1)
      items  = [
        {
          name_or_url: "http://www.submarino.com.br/produto/119195941/cafeteira-expresso-nespresso-19-bar-ruby-red-inissia", 
          comments: ""
        }, 
        {
          name_or_url: "http://www.americanas.com.br/produto/110636085/box-jogos-vorazes-1-ed-pin", 
          comments: ""
        }
      ]

      WishlistService.new(group, person).update("", items)
    end

    let(:person) { Person.find(1) }
    let(:group) { Group.find(1) }

    it 'returns a list of items' do
      expect(person.wishlist_items(group)).to_not be_nil
      expect(person.wishlist_items(group)).to_not be_empty
      expect(person.wishlist_items(group)).to include(a_kind_of(WishlistItem))
    end
  end

end