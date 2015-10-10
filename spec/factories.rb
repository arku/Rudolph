# -*- coding: utf-8 -*-

FactoryGirl.define do

  # --------- PEOPLE --------- #

  factory :flora, class: Person do
    id 1
    name 'Flora Saramago'
    email 'flora@itsrudolph.com'
    password 'florapassword'
  end

  factory :daniel, class: Person do
    id 2
    email 'daniel@itsrudolph.com'
    password 'danielpassword'
  end

  factory :aline, class: Person do
    id 3
    email 'aline@itsrudolph.com'
    password 'alinepassword'
  end

  factory :carolina, class: Person do
    id 4
    email 'carolina@itsrudolph.com'
    password 'carolinapassword'
  end

  factory :celio, class: Person do
    id 5
    email 'celio@itsrudolph.com'
    password 'celiopassword'
  end

  factory :eduardo, class: Person do
    id 6
    email 'eduardo@itsrudolph.com'
    password 'eduardopassword'
  end

  factory :emanuela, class: Person do
    id 7
    email 'emanuela@itsrudolph.com'
    password 'emanuelapassword'
  end

  factory :fernando, class: Person do
    id 8
    email 'fernando@itsrudolph.com'
    password 'fernandopassword'
  end

  factory :julia, class: Person do
    id 9
    email 'julia@itsrudolph.com'
    password 'juliapassword'
  end

  factory :paula, class: Person do
    id 10
    email 'paula@itsrudolph.com'
    password 'paulapassword'
  end

  factory :ronaldo, class: Person do
    id 11
    email 'ronaldo@itsrudolph.com'
    password 'ronaldopassword'
  end

  factory :thais, class: Person do
    id 12
    email 'thais@itsrudolph.com'
    password 'thaispassword'
  end

  factory :colleague, class: Person do
    id 13
    email 'colleague@itsrudolph.com'
    password 'colleaguepassword'
  end

  factory :pending_person, class: Person do
    id 14
    email 'pending@itsrudolph.com'
    password 'pendingpassword'
    invitation_token 'abcd1234'
    invitation_accepted_at nil
  end

  factory :invitation_accepted_person, class: Person do
    id 15
    email 'accepted@itsrudolph.com'
    password 'acceptedpassword'
    invitation_token nil
    invitation_accepted_at Time.now
  end


  # --------- GROUPS --------- #

  factory :school_friends, class: Group do
    id 1
    admin_id 1
    name 'School Friends'
    description 'Secret Santa with old friends from school.'
    date '2015-12-20 20:00:00'
    location 'Cosme Velho'
    price_range 'R$50 - R$60'
  end

  factory :work_friends, class: Group do
    id 2
    admin_id 1
    name 'Work Friends'
    description 'Secret Santa with new friends from work.'
    date '2015-12-20 20:00:00'
    location 'Office'
    price_range 'R$60 - R$70'
  end


  # --------- GROUP PEOPLE --------- #


  factory :group_person_2, class: GroupPerson do
    id 3
    group_id 1
    person_id 2
    confirmed 1
  end

  factory :group_person_3, class: GroupPerson do
    id 4
    group_id 1
    person_id 3
    confirmed 1
  end

  factory :group_person_4, class: GroupPerson do
    id 5
    group_id 1
    person_id 4
    confirmed 1
  end

  factory :group_person_5, class: GroupPerson do
    id 6
    group_id 1
    person_id 5
    confirmed 1
  end

  factory :group_person_6, class: GroupPerson do
    id 7
    group_id 1
    person_id 6
    confirmed 1
  end

  factory :group_person_7, class: GroupPerson do
    id 8
    group_id 1
    person_id 7
    confirmed 1
  end

  factory :group_person_8, class: GroupPerson do
    id 9
    group_id 1
    person_id 8
    confirmed 1
  end

  factory :group_person_9, class: GroupPerson do
    id 10
    group_id 1
    person_id 9
    confirmed 1
  end

  factory :group_person_10, class: GroupPerson do
    id 11
    group_id 1
    person_id 10
    confirmed 1
  end

  factory :group_person_11, class: GroupPerson do
    id 12
    group_id 1
    person_id 11
    confirmed 1
  end

  factory :group_person_12, class: GroupPerson do
    id 13
    group_id 1
    person_id 12
    confirmed 1
  end

  factory :group_person_14, class: GroupPerson do
    id 14
    group_id 2
    person_id 13
    confirmed 1
  end

end