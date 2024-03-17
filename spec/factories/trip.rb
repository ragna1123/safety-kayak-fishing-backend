# frozen_string_literal: true

FactoryBot.define do
  factory :trip do
    association :user
    association :location
    departure_time { Time.zone.now + 3.hours } # 現在時刻から3時間後
    estimated_return_time { Time.zone.now + 8.hours } # 現在時刻から8時間後
    details { Faker::Lorem.sentence }
  end
end
