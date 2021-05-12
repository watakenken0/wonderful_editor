require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /articles" do
    # before {create(:article)}
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 2.days.ago) }
    let!(:article3) { create(:article) }

    it "記事の一覧が取得できる" do
      subject
      # binding.pry
      res = JSON.parse(response.body)
      binding.pry
      expect(response).to have_http_status(:ok)
      expect(res["articles"].length).to eq 3
      expect(res["articles"][0].keys).to eq ["title", "updated_at", "user"]
      expect(res["articles"][0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "GET/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定しているariticle_idが存在している時" do
      let(:article) { FactoryBot.create(:article) }
      let(:article_id) { article.id }

      it "記事の詳細を表示させる" do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res["article"].keys).to eq ["title", "content", "updated_at", "user_id", "id", "user"]
      end
    end

    context "指定したarticle_idが存在しない時" do
      let(:article_id) { 10000 }
      it "記事の詳細を見ることが出来ない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    let(:headers){ current_user.create_new_auth_token}

    fit "記事のレコードが作成できる" do
      expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
      res = JSON.parse(response.body)
      expect(res["title"]).to eq params[:article][:title]
      expect(res["body"]).to eq params[:article][:body]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH/article/id" do
    subject { patch(api_v1_article_path(article_id), params: params, headers: headers) }

    let(:params) { { article: { title: Faker::Name.name, created_at: 1.day.ago } } }
    let(:article_id) { article.id }
    # articleのデータにuserを紐付けする方法は↓
    let(:article) { create(:article, user: current_user) }
    let!(:current_user) { create(:user) }
    let(:headers){ current_user.create_new_auth_token}
    context "自分が所持している記事のレコードを更新しようとしたとき" do
      it "レコードを更新できる" do
        expect { subject }.to change { Article.find(article_id).title }.from(article.title).to(params[:article][:title]) &
                              not_change { Article.find(article_id).created_at } &
                              not_change { Article.find(article_id).content }
      end
    end

    context "自分が所持していない記事のレコードを更新しようとするとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end

  describe "DELETE/articles/id" do
    subject { delete(api_v1_article_path(article_id),headers: headers) }
    let(:article_id) { article.id }
    let!(:article) { create(:article, user: current_user) }
    let!(:current_user) { create(:user) }
    let(:headers){ current_user.create_new_auth_token}


    context "任意のユーザーの記事を削除しようとしたとき" do
      fit "削除できる" do
        expect { subject }.to change { Article.count }.by(-1)
      end
    end
    #ここは模範回答を参考にした
    context "他人の所持している記事のレコードを削除しようとするとき" do
    let!(:other_user) {create(:user)}
    let(:article) {create(:article, user: other_user)}
    it "削除することができない" do
    expect {subject}.to raise_error(ActiveRecord::RecordNotFound)& change {Article.count}.by(0)

    end
    end

  end
end
