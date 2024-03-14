FactoryBot.define do
  factory :trip do
    association :user
    association :location
    departure_time { '2024-03-15 08:00:00' }
    estimated_return_time { '2024-03-15 18:00:00' }
    details { '東京湾での釣り' }
  end

end
