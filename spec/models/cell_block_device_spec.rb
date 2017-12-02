require "spec_helper"

RSpec.describe CellBlockDevice do

  let(:cell_block_device) { FactoryBot.create :cell_block_device }

  it { is_expected.to belong_to(:cell) }
  it do
    is_expected.to have_many(:volumes).class_name("CellVolume").dependent(:destroy)
  end

  describe "#serializable_hash" do
    subject { cell_block_device.serializable_hash }

    let(:cell_block_device_data) do
      {
        "device"             => cell_block_device.device,
        "total_capacity"     => cell_block_device.total_capacity,
        "available_capacity" => cell_block_device.available_capacity,
        "status"             => cell_block_device.status,
        "volumes"            => cell_block_device.volumes,
        "created_at"         => be_a(Time),
        "updated_at"         => be_a(Time)
      }
    end

    it { is_expected.to match cell_block_device_data }
  end

end
