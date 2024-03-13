# frozen_string_literal: true

class TripController < ApplicationController
  before_action :jwt_authenticate

  def create; end
end
