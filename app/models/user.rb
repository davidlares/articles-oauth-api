class User < ApplicationRecord
  # adding validations
  validates :login, presence: true, uniqueness: true
  validates :provider, presence: true
end
