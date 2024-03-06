class EmergencyContact < ApplicationRecord
  validates :name, presence: true
  validates :relationship, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone_number, allow_nil: true
  validates :line_id, allow_nil: true
end
