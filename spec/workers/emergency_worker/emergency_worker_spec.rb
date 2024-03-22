require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe EmergencyMailWorker, type: :worker do
  let(:user) { create(:user) }
  let(:trip) { create(:trip, user: user, departure_time: 2.hours.ago, estimated_return_time: 1.hour.ago) }
  let!(:emergency_contact) { create(:emergency_contact, user: user) }

  describe "#perform" do
    it "sends an emergency email" do
      Sidekiq::Testing.inline! do
        expect {
          EmergencyMailWorker.perform_async(trip.id)
        }.to change { ActionMailer::Base.deliveries.size }.by(1)
      end
    end
  end

  after do
    Sidekiq::Testing.fake!
  end
end
