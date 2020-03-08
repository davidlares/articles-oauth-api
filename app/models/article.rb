class Article < ApplicationRecord
  # adding validations
  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true

  # adding recent function
  scope :recent, -> {order(created_at: :desc)}
end
