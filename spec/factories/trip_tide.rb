# frozen_string_literal: true

FactoryBot.define do
  factory :trip_tide do
    association :trip
    association :tide_data
  end
end
