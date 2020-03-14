class Comment < ApplicationRecord
  belongs_to :articles
  belongs_to :user
end
