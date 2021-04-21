module Api::V1
  class ArticlesController < BaseApiController
    def index
      articles = Article.order(updated_at: :desc)
      binding.pry
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      article = Article.find(params[:id])
      binding.pry
      render json: article, serializer: Api::V1::ArticleViewSerializer
    end
  end
end
