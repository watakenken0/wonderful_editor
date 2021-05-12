module Api::V1
  class ArticlesController < BaseApiController
    before_action :authenticate_user!, only: [:create, :update, :destory]
    def index
      @articles = Article.order(updated_at: :desc)
      render json: @articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      @article = Article.find(params[:id])
      render json: @article, serializer: Api::V1::ArticleViewSerializer
    end

    def create
      binding.pry
      @article = current_user.articles.create!(article_params)
      render json: @article, each_serializer: Api::V1::ArticleViewSerializer
    end

    def update
      binding.pry
      @article = current_user.articles.find(params[:id])
      @article.update!(article_params)
      binding.pry
      render json: @article, each_serializer: Api::V1::ArticleViewSerializer
    end

    def destroy
      # 対象のレコードを探す
      @article = current_user.articles.find(params[:id])
      # 探してきたレコードを削除する
      @article.destroy!
    end

    private

      def article_params
        binding.pry
        params.require(:article).permit(:title, :content)
      end
  end
end
