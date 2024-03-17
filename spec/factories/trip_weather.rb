# frozen_string_literal: true

FactoryBot.define do
  factory :trip_weather do
    association :trip
    association :weather_data, factory: :weather_data
  end
end
