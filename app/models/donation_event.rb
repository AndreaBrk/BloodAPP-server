class DonationEvent < ApplicationRecord
  belongs_to :user
  enum status: [:open, :done]
end
