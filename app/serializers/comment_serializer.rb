class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content
  has_one :articles
  has_one :user
end
