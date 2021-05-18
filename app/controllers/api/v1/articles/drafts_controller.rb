module Api::V1::Articles
  class DraftsController < Api::V1::BaseApiController
    before_action :authenticate_user!
    def index
      @article = current_user.articles.where(status: 0)
      render json: @article, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      @article = current_user.articles.where(status: 0)
      @article = @article.find(params[:id])
      render json: @article, serializer: Api::V1::ArticleViewSerializer
    end
end
end
