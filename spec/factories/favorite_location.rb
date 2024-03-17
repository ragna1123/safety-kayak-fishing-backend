# frozen_string_literal: true

FactoryBot.define do
  factory :favorite_location do
    association :user
    association :location
    location_name { Faker::Address.city }
    description { Faker::Lorem.sentence }
  end
end
