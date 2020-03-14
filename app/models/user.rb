class User < ApplicationRecord
  # adding validations
  validates :login, presence: true, uniqueness: true
  validates :provider, presence: true
  # adding relation with access_token
  has_one :access_token, dependent: :destroy
  has_many :articles, dependent: :destroy
end
