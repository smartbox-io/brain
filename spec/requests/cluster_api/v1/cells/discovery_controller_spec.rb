require "spec_helper"

RSpec.describe ClusterApi::V1::Cells::DiscoveryController do
  subject { response }

  let(:cell) { FactoryBot.build :cell }
  let(:cell_params) do
    {
      cell: {
        uuid:              cell.uuid,
        fqdn:              cell.fqdn,
        block_devices:     {
          "sdb" => {
            total_capacity: 2048,
            partitions:     {
              "sdb1" => {
                total_capacity: 1024
              },
              "sdb2" => {
                total_capacity: 1024
              }
            }
          }
        },
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

  context "a new cell is discovered" do
    def create
      post cluster_api_v1_discovery_path, params:  cell_params.to_json,
                                          headers: json_content_type
    end

    it "creates a new cell" do
      expect { create }.to change { Cell.count }.by 1
    end

    describe "http response" do
      before { create }

      it { is_expected.to have_http_status :ok }
    end
  end
end
