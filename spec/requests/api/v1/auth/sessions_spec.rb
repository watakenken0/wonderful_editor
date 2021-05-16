require 'rails_helper'

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /auth/sign_in" do
    subject {post(api_v1_user_session_path, params: params)}
    context "適切で指名したパラメーターを送信した時" do
      let!(:user) {create(:user)}
      let(:params) { {name: user.name, email: user.email, password: user.password}}

      it "ログインできる" do
        binding.pry
        subject
        header = response.header
        binding.pry
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["expiry"]).to be_present
        expect(header["uid"]).to be_present
        expect(header["token-type"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "emailが間違っている時" do
      let!(:user) {create(:user)}
      let(:params) { {name: user.name, email: "abcdefg", password: user.password}}

      it "ログインできない" do
        binding.pry
        subject
        header = response.header
        expect(header["access-token"]).not_to be_present
        expect(header["client"]).not_to be_present
        expect(header["expiry"]).not_to be_present
        expect(header["uid"]).not_to be_present
        expect(header["token-type"]).not_to be_present
      end
    end
    context "passwordが間違っている時" do
      let!(:user) {create(:user)}
      let(:params) { {name: user.name, email: user.email, password: "aabbccddee"}}

      it "ログインできない" do
        binding.pry
        subject
        header = response.header
        expect(header["access-token"]).not_to be_present
        expect(header["client"]).not_to be_present
        expect(header["expiry"]).not_to be_present
        expect(header["uid"]).not_to be_present
        expect(header["token-type"]).not_to be_present
      end
    end

    describe "DELETE/sign_out" do
      subject {delete(destroy_api_v1_user_session_path, headers: headers)}
      context "ログインしている時" do
        let(:user) {create(:user)}
        let(:headers){ user.create_new_auth_token}
        fit "ログアウトできる" do
          binding.pry
          subject
          res = response.header
          expect(response).to have_http_status(:ok)
          expect(user.reload.tokens).to be_blank
        end
      end
      context "uid,client,access-tokenのうちどれか一つでも値がない場合" do
        let(:user) {create(:user)}
        let(:headers) { {"uid": "", "client": "", "access-token": ""  }}
        it "ログアウトできない" do
          binding.pry
          subject
          res = JSON.parse(response.body)
          expect(response).to have_http_status(404)
          expect(res["errors"]).to include "User was not found or was not logged in."
        end
      end
    end

  end
end
