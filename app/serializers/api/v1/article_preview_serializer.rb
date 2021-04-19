class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  attributes :title, :updated_at
  belongs_to :user, serializer: Api::V1::UserSerializer
end
