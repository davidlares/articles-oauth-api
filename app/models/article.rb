class Article < ApplicationRecord
  # adding validations
  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true

  belongs_to :user
  # adding recent function
  scope :recent, -> {order(created_at: :desc)}
end
