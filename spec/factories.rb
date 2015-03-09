# -*- coding: utf-8 -*-

FactoryGirl.define do

  # --------- PEOPLE --------- #

  factory :flora, class: Person do
    id 1
    email 'flora@rudolph.com'
    password 'florapassword'
  end

  factory :daniel, class: Person do
    id 2
    email 'daniel@rudolph.com'
    password 'danielpassword'
  end

  factory :aline, class: Person do
    id 3
    email 'aline@rudolph.com'
    password 'alinepassword'
  end

  factory :carolina, class: Person do
    id 4
    email 'carolina@rudolph.com'
    password 'carolinapassword'
  end

  factory :celio, class: Person do
    id 5
    email 'celio@rudolph.com'
    password 'celiopassword'
  end

  factory :eduardo, class: Person do
    id 6
    email 'eduardo@rudolph.com'
    password 'eduardopassword'
  end

  factory :emanuela, class: Person do
    id 7
    email 'emanuela@rudolph.com'
    password 'emanuelapassword'
  end

  factory :fernando, class: Person do
    id 8
    email 'fernando@rudolph.com'
    password 'fernandopassword'
  end

  factory :julia, class: Person do
    id 9
    email 'julia@rudolph.com'
    password 'juliapassword'
  end

  factory :paula, class: Person do
    id 10
    email 'paula@rudolph.com'
    password 'paulapassword'
  end

  factory :ronaldo, class: Person do
    id 11
    email 'ronaldo@rudolph.com'
    password 'ronaldopassword'
  end

  factory :thais, class: Person do
    id 12
    email 'thais@rudolph.com'
    password 'thaispassword'
  end

  factory :colleague, class: Person do
    id 13
    email 'colleague@rudolph.com'
    password 'colleaguepassword'
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

  factory :group_person_1, class: GroupPerson do
    id 1
    group_id 1
    person_id 1
  end

  factory :group_person_2, class: GroupPerson do
    id 2
    group_id 1
    person_id 2
  end

  factory :group_person_3, class: GroupPerson do
    id 3
    group_id 1
    person_id 3
  end

  factory :group_person_4, class: GroupPerson do
    id 4
    group_id 1
    person_id 4
  end

  factory :group_person_5, class: GroupPerson do
    id 5
    group_id 1
    person_id 5
  end

  factory :group_person_6, class: GroupPerson do
    id 6
    group_id 1
    person_id 6
  end

  factory :group_person_7, class: GroupPerson do
    id 7
    group_id 1
    person_id 7
  end

  factory :group_person_8, class: GroupPerson do
    id 8
    group_id 1
    person_id 8
  end

  factory :group_person_9, class: GroupPerson do
    id 9
    group_id 1
    person_id 9
  end

  factory :group_person_10, class: GroupPerson do
    id 10
    group_id 1
    person_id 10
  end

  factory :group_person_11, class: GroupPerson do
    id 11
    group_id 1
    person_id 11
  end

  factory :group_person_12, class: GroupPerson do
    id 12
    group_id 1
    person_id 12
  end

  factory :group_person_13, class: GroupPerson do
    id 13
    group_id 2
    person_id 1
  end

  factory :group_person_14, class: GroupPerson do
    id 14
    group_id 2
    person_id 13
  end

end