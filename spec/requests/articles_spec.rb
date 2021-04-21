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
      expect(res["articles"][0]["user"].keys).to eq ["id", "user", "email"]
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
        binding.pry

        expect(response).to have_http_status(:ok)
        expect(res["article"].keys).to eq ["title", "content", "updated_at", "user_id", "id", "user"]
      end
    end

    context "指定したarticle_idが存在しない時" do
      let(:article_id) { 1000 }
      it "記事の詳細を見ることが出来ない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end


end
