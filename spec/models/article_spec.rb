# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  content    :text
#  status     :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
    context "titleとcontentが空白ではない時" do
      let!(:article) {create(:article, status: 0) }
      fit "下書きとして保存できる" do

      expect(article).to be_valid
      expect(article.status).to eq "draft"
      end
    end


    context "titleとcontent空白ではない時" do
      let!(:article) { create(:article, status: 1) }
      fit "公開として保存" do
      expect(article).to be_valid
      expect(article.status).to eq "published"
      end
    end

end
