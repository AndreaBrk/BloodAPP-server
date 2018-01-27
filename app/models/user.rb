class User < ActiveRecord::Base
  rolify
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable,
          :omniauthable # :confirmable, :validatable
  include DeviseTokenAuth::Concerns::User
  has_many :donation_events
end
