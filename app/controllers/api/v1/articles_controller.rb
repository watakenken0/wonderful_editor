module Api::V1
  class ArticlesController < BaseApiController
    before_action :authenticate_user!, only: [:create, :update, :destory]
    def index
      @article = Article.where(status: 1)
      @article = @article.order(updated_at: :desc)
      render json: @article, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      @article = Article.where(status: 1)
      @article = @article.find(params[:id])
      render json: @article, serializer: Api::V1::ArticleViewSerializer
    end

    def create
      @article = current_user.articles.create!(article_params)
      render json: @article, each_serializer: Api::V1::ArticleViewSerializer
    end

    def update
      @article = current_user.articles.find(params[:id])
      @article.update!(article_params)
      render json: @article, each_serializer: Api::V1::ArticleViewSerializer
    end

    def destroy
      @article = current_user.articles.find(params[:id])
      @article.destroy!
    end

    private

      def article_params
        params.require(:article).permit(:title, :content,:status)
      end
  end
end
