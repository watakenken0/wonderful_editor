class Api::V1::ArticleViewSerializer < ActiveModel::Serializer
  attributes :title, :content, :updated_at, :user_id, :id, :status
  belongs_to :user, serializer: Api::V1::UserSerializer
end
