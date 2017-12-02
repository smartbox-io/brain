require "spec_helper"

RSpec.describe ClusterApi::V1::Cells::BlockDevicesController do
  subject { response }

  let(:cell) { FactoryBot.create :cell }
  let(:block_devices_params) do
    {
      cell: {
        block_devices: [
          {
            device:  :sdb,
            status:  :healthy,
            volumes: [
              {
                volume: :sdb1,
                status: :healthy
              },
              {
                volume: :sdb2,
                status: :healthy
              }
            ]
          },
          {
            device:  :sdc,
            status:  :healthy,
            volumes: [
              {
                volume: :sdc1,
                status: :healthy
              },
              {
                volume: :sdc2,
                status: :healthy
              }
            ]
          }
        ]
      }
    }
  end

  before do
    sdb = FactoryBot.create :cell_block_device, cell: cell, device: :sdb
    sdc = FactoryBot.create :cell_block_device, cell: cell, device: :sdc
    FactoryBot.create_list :cell_volume, 2, cell_block_device: sdb
    FactoryBot.create_list :cell_volume, 2, cell_block_device: sdc
  end

  describe "#update" do
    def update
      patch cluster_api_v1_block_devices_path(cell), params: block_devices_params
    end

    before do
      update
    end

    it { is_expected.to have_http_status :ok }
  end
end
