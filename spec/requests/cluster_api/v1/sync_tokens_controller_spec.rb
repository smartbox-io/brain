require "spec_helper"

RSpec.describe ClusterApi::V1::SyncTokensController do
  subject { response }

  let(:sync_token) { FactoryGirl.create :sync_token }
  let(:remote_ip) { sync_token.target_cell_volume.cell.ip_address }

  before { show }

  describe "#show" do
    context "sync token does exist" do
      def show
        get cluster_api_v1_sync_token_path(sync_token.token), headers: ip(remote_ip)
      end

      it { is_expected.to have_http_status :ok }
    end

    context "sync token does not exist" do
      def show
        get cluster_api_v1_sync_token_path(SecureRandom.uuid), headers: ip(remote_ip)
      end

      it { is_expected.to have_http_status :forbidden }
    end
  end

  describe "#show" do
    def show
      get cluster_api_v1_sync_token_path(sync_token.token), headers: ip(remote_ip)
    end

    subject { json }

    it { is_expected.to include(:object, :source_cell, :target_cell) }
  end
end
