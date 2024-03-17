# frozen_string_literal: true

FactoryBot.define do
  factory :emergency_contact do
    association :user
    name { Faker::Name.name }
    relationship { Faker::Lorem.word }
    phone_number { Faker::PhoneNumber.cell_phone}
    email { Faker::Internet.email }
    line_id { Faker::Lorem.word }
  end
end