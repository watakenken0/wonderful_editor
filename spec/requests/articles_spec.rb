require 'rails_helper'

RSpec.describe "Api::V1::Articles", type: :request do
    fdescribe "GET /articles" do
      let!(:article1) { create(:article, updated_at: 1.days.ago) }
      let!(:article2) { create(:article, updated_at: 2.days.ago) }
      let!(:article3) { create(:article) }


      #before {create(:article)}
       subject { get(api_v1_articles_path) }


       it "記事の一覧が取得できる" do

        subject
        #binding.pry
       res = JSON.parse(response.body)
        binding.pry
        expect(response).to have_http_status(200)
        expect(res["articles"].length).to eq 3
        expect(res["articles"][0].keys).to eq [ "title", "updated_at", "user"]
        expect(res["articles"][0]["user"].keys).to eq [ "id","user", "email"]
      end
end

# describe "GET/articles/:id" do

#   subject{get(api_v1_articles_path(article_id))}
#   let(:user_id) { article.id }
#   let(:article) {FactoryBot.create(:article)}

#   it "記事の詳細を表示させる" do
#     subject
#     binding.pry
#     expect(response).to have_http_status(200)
#     expect()
#   end
#end

end
