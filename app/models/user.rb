# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, presence: true
  validates :email, presence: true, uniqueness: true
  has_secure_password
  VALID_PASSWORD_REGEX = /\A[\w-]+\z/
  validates :password, presence: true,
                       length: { minimum: 6 },
                       format: {
                         with: VALID_PASSWORD_REGEX
                       },
                       allow_nil: true
end
