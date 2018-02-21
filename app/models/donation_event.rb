class DonationEvent < ApplicationRecord
  belongs_to :user
  enum status: [:open, :done]
  validates :name, presence: name
  validates :size, presence: name
  validates :blood_type, presence: name
end
