require "spec_helper"

RSpec.describe Api::V1::SessionsController do
  subject { response }

  let(:user) { FactoryGirl.create :user }
  let(:refresh_token) { user.refresh_tokens.create }

  describe "#create" do
    let(:password) { "password" }

    def create
      post api_v1_sessions_path, params: { username: user.username,
                                           password: password }
    end

    before { create }

    context "with valid login information" do
      it { is_expected.to have_http_status :ok }

      it "creates a refresh token" do
        expect { create }.to change { user.refresh_tokens.count }.by 1
      end

      it "renders the JWT" do
        expect(json).to include(:access_token, :expires_in, :refresh_token)
      end
    end

    context "with invalid login information" do
      let(:password) { "invalid_password" }

      it { is_expected.to have_http_status :forbidden }

      it "does not create a refresh token" do
        expect { create }.not_to(change { user.refresh_tokens.count })
      end
    end
  end

  describe "#update" do
    def update
      patch api_v1_sessions_path, params:  { refresh_token: refresh_token.token },
                                  headers: token_auth(user)
    end

    context "with valid refresh token" do
      before { update }

      it { is_expected.to have_http_status :ok }

      it "renders the JWT" do
        expect(json).to include(:access_token, :expires_in, :refresh_token)
      end
    end

    context "with valid refresh token" do
      it "invalidates the current refresh token" do
        expect { update }.to change { user.refresh_tokens.exists?(token: refresh_token.token) }
          .from(true).to(false)
      end
    end

    context "with invalid refresh token" do
      let(:refresh_token) { user.refresh_tokens.build }

      before { update }

      it { is_expected.to have_http_status :forbidden }
    end
  end

  describe "#destroy" do
    def destroy
      delete api_v1_sessions_path, params:  { refresh_token: refresh_token.token },
                                   headers: token_auth(user)
    end

    context "with valid refresh token" do
      before { destroy }

      it { is_expected.to have_http_status :ok }
    end

    context "with valid refresh token" do
      it "invalidates the current refresh token" do
        expect { destroy }.to change { user.refresh_tokens.exists?(token: refresh_token.token) }
          .from(true).to(false)
      end
    end

    context "with invalid refresh token" do
      let(:refresh_token) { user.refresh_tokens.build }

      before { destroy }

      it { is_expected.to have_http_status :forbidden }
    end
  end
end
