require 'rails_helper'

RSpec.describe "Drafts", type: :request do
  describe "GET /index" do
    subject {get(api_v1_articles_drafts_path, headers: headers)}
    let!(:article1) { create(:article, user: current_user, updated_at: 1.days.ago, status: 0) }
    let!(:article2) { create(:article, user: current_user,  updated_at: 2.days.ago, status: 0) }
    let!(:article3) { create(:article, user: current_user, status: 0) }
    let!(:current_user) { create(:user) }
    let!(:headers){ current_user.create_new_auth_token}

    context "ログイン中、自分の下書き記事の一覧を参照するAPIを叩いた時" do
      fit "下書き一覧を表示する" do
        subject
      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(res["articles"].length).to eq 3
      expect(res["articles"][0].keys).to eq ["title", "updated_at", "user"]
      expect(res["articles"][0]["user"].keys).to eq ["id", "name", "email"]
      end
  end
end

  describe "get/article/drafts/:id" do
    subject {get(api_v1_articles_draft_path(article_id),headers: headers)}
    let!(:current_user) { create(:user) }
    let!(:headers){ current_user.create_new_auth_token}

    context "ログイン中、指定した下書きのarticle_idが存在している時" do
      let!(:article) { create(:article, user: current_user,status: 0) }
      let(:article_id) {article.id}
      fit "下書きの詳細を参照することが出来る" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        binding.pry
        expect(res["article"].keys).to eq ["title", "content", "updated_at", "user_id", "id","status","user"]
        expect(res["article"]["id"]).to eq article.id
      end
    end

    context "ログイン中、指定したidの下書きが存在しない時" do
      let(:article_id) { 10000 }
      fit "記事の詳細を表示しない。" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
