# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  has_secure_password
  VALID_PASSWORD_REGEX = /\A[\w-]+\z/
  validates :password, presence: true,
                       length: { minimum: 6 },
                       format: {
                         with: VALID_PASSWORD_REGEX
                       },
                       allow_nil: true

  has_many :trips, dependent: :destroy
  has_many :favorite_locations, dependent: :destroy
  has_many :emergency_contacts, dependent: :destroy
  has_many :feedbacks
end
