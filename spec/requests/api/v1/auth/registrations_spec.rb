require 'rails_helper'

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /registratoins" do
    subject{post(api_v1_user_registration_path,params: params) }
    context "適切なパラメーターを送信できた時" do
      let(:params) { {name: Faker::Name.name, email: Faker::Internet.email, password: "rooooot", password_confirmation: "rooooot"} }
      it "ユーザーが新規作成される" do
        expect { subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)
        expect(res["data"]["email"]).to eq(User.last.email)
        expect(res["data"]["name"]).to eq(User.last.name)
      end
      it "ヘッダーとトークンが返ってくる" do
        subject
        header = response.header

        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["expiry"]).to be_present
        expect(header["uid"]).to be_present
        expect(header["token-type"]).to be_present
    end
  end
  context "ユーザー作成時にpasswordがない時" do
    let(:params) { {name: Faker::Name.name, email: Faker::Internet.email, password: "", password_confirmation: ""}}
    it "ユーザーが作成されない" do

      subject
      res = JSON.parse(response.body)
      expect(res["data"]["password"]).to be nil
      expect(response).to have_http_status(422)
  end
  end
  context "ユーザー作成時にemailがない時" do
   let(:params){{name: Faker::Name.name, email: nil, password: "rooooot", password_confirmation: "rooooot" }}
  it "ユーザーが作成されない" do
      subject
      res = JSON.parse(response.body)
      expect(res["data"]["email"]).to be nil
      expect(response).to have_http_status(422)
  end
  end
end
end
