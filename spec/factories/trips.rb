# spec/factories/trips.rb

FactoryBot.define do
  factory :trip do
    association :user
    departure_time { '2024-03-15 08:00:00' }
    estimated_return_time { '2024-03-15 18:00:00' }
    details { '東京湾での釣り' }
    
    after(:build) do |trip|
      location = create(:location, latitude: '35.681236', longitude: '139.767125')
      trip.location = location
    end
  end
end

