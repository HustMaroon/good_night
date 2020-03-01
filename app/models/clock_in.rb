class ClockIn < ApplicationRecord
  include ActiveModel::Serialization
  belongs_to :user
  validates :user_id, presence: true
end
