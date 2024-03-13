# frozen_string_literal: true

class Feedback < ApplicationRecord
  validates :user_id, presence: true
  validates :title, presence: true
  validates :comment, presence: true, length: { maximum: 255 }
  belongs_to :user
end
