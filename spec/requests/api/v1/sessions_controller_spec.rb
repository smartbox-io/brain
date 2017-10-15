require "spec_helper"

RSpec.describe Api::V1::SessionsController do
  subject { response }

  let(:user) { FactoryGirl.create :user }
  let(:refresh_token) { user.refresh_tokens.create }

  describe "#create" do
    def create
      post api_v1_sessions_path(format: :json), params: { username: user.username,
                                                          password: "password" }
    end

    before { create }

    it { is_expected.to have_http_status(:ok) }

    it "creates a refresh token" do
      expect { create }.to change { user.refresh_tokens.count }.by 1
    end

    it "includes the JWT keys" do
      expect(json).to include(:access_token, :expires_in, :refresh_token)
    end
  end
end
