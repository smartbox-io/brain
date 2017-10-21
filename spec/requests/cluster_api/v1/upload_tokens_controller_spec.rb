require "spec_helper"

RSpec.describe ClusterApi::V1::UploadTokensController do
  subject { response }

  let(:upload_token) { FactoryBot.create :upload_token }
  let(:cell) { upload_token.cell_volume.cell }
  let(:user) { upload_token.user }
  let(:remote_ip) { upload_token.remote_ip }

  describe "#show" do
    context "upload token exists" do
      before do
        get cluster_api_v1_upload_token_path(upload_token.token, params: {
                                               client_ip: remote_ip
                                             }), headers: token_auth(user)
      end

      it { is_expected.to have_http_status :ok }
    end

    context "upload token does not exist" do
      before do
        get cluster_api_v1_upload_token_path("invalid-token", params: {
                                               client_ip: remote_ip
                                             }), headers: token_auth(user)
      end

      it { is_expected.to have_http_status :forbidden }
    end

    context "unknown cell raises a forbidden error" do
      before do
        get cluster_api_v1_upload_token_path(upload_token.token, params: {
                                               client_ip: remote_ip
                                             }), headers: token_auth(user)
                                               .merge(ip("255.255.255.255"))
      end

      it { is_expected.to have_http_status :forbidden }
    end
  end

  describe "#show" do
    subject { json }

    before do
      get cluster_api_v1_upload_token_path(upload_token.token, params: {
                                             client_ip: remote_ip
                                           }), headers: token_auth(user)
    end
    it { is_expected.to include(:volume) }
  end
end
