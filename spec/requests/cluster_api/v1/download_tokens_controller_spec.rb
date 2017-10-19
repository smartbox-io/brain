require "spec_helper"

RSpec.describe ClusterApi::V1::DownloadTokensController do
  subject { response }

  let(:download_token) { FactoryGirl.create :download_token }
  let(:cell) { download_token.cell_volume.cell }
  let(:user) { download_token.user }

  describe "#show" do
    context "download token exists" do
      before do
        get cluster_api_v1_download_token_path(download_token.token, params: {
                                                 client_ip: download_token.remote_ip
                                               }), headers: token_auth(user)
      end

      it { is_expected.to have_http_status :ok }
    end

    context "download token does not exist" do
      before do
        get cluster_api_v1_download_token_path("invalid-token", params: {
                                                 client_ip: download_token.remote_ip
                                               }), headers: token_auth(user)
      end

      it { is_expected.to have_http_status :forbidden }
    end
  end
end
