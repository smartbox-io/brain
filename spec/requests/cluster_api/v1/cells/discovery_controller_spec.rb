require "rails_helper"

RSpec.describe ClusterApi::V1::Cells::DiscoveryController do
  subject { response }

  let(:cell) { FactoryGirl.build :cell }
  let(:cell_params) do
    {
      cell: {
        uuid:              cell.uuid,
        fqdn:              cell.fqdn,
        volumes:           {
          "/data" => {
            total_capacity:     2048,
            available_capacity: 2048
          }
        },
        public_ip_address: IPAddr.new(rand(2**32), Socket::AF_INET).to_s
      }
    }
  end
  let(:request) do
    post cluster_api_v1_discovery_path(format: :json),
         params:  cell_params.to_json,
         headers: { "Content-Type" => "application/json" }
  end

  context "a new cell is discovered" do
    it "creates a new cell" do
      expect { request }.to change { Cell.count }.by(1)
    end

    describe "http return status" do
      before { request }

      it { is_expected.to have_http_status(:ok) }
    end
  end
end
