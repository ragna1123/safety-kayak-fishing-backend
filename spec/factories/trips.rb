FactoryBot.define do
  factory :trip do
    association :user
    departure_time { '2024-03-15 08:00:00' }
    estimated_return_time { '2024-03-15 18:00:00' }
    details { '東京湾での釣り' }

    transient do
      location_data { { latitude: '35.681236', longitude: '139.767125' } }
    end

    after(:build) do |trip, evaluator|
      location = create(:location, latitude: evaluator.location_data[:latitude], longitude: evaluator.location_data[:longitude])
      trip.location = location
    end
  end
end
