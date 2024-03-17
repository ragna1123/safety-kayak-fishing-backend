# frozen_string_literal: true

class EmergencyContact < ApplicationRecord
  validates :name, presence: true
  validates :relationship, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  
  belongs_to :user
end
