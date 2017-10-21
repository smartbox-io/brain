require "spec_helper"

RSpec.describe ClusterApi::V1::DownloadTokensController do
  subject { response }

  let(:download_token) { FactoryBot.create :download_token }
  let(:cell) { download_token.cell_volume.cell }
  let(:user) { download_token.user }
  let(:remote_ip) { download_token.remote_ip }

  describe "#show" do
    context "download token exists" do
      before do
        get cluster_api_v1_download_token_path(download_token.token, params: {
                                                 client_ip: remote_ip
                                               }), headers: token_auth(user)
      end

      it { is_expected.to have_http_status :ok }
    end

    context "download token does not exist" do
      before do
        get cluster_api_v1_download_token_path("invalid-token", params: {
                                                 client_ip: remote_ip
                                               }), headers: token_auth(user)
      end

      it { is_expected.to have_http_status :forbidden }
    end

    context "unknown cell raises a forbidden error" do
      before do
        get cluster_api_v1_download_token_path(download_token.token, params: {
                                                 client_ip: remote_ip
                                               }), headers: token_auth(user)
                                                 .merge(ip("255.255.255.255"))
      end

      it { is_expected.to have_http_status :forbidden }
    end
  end
end
