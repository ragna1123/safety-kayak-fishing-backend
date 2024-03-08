# frozen_string_literal: true

class EmergencyContact < ApplicationRecord
  validates :name, presence: true
  validates :relationship, presence: true
  validates :email, presence: true, uniqueness: true
end
