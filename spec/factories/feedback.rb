# frozen_string_literal: true

# spec/factories/feedbacks.rb
FactoryBot.define do
  factory :feedback do
    association :user
    title { Faker::Lorem.sentence }
    comment { Faker::Lorem.paragraph }
  end
end
