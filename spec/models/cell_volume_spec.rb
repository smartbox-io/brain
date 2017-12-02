require "spec_helper"

RSpec.describe CellVolume do
  let(:cell_volume) { FactoryBot.create :cell_volume }

  it { is_expected.to belong_to :cell_block_device }
  it { is_expected.to have_one(:cell).through :cell_block_device }
  it {
    is_expected.to have_many(:object_backups).conditions(is_backup: true)
                                             .class_name("FullObjectReplica")
  }
  it {
    is_expected.to have_many(:object_replicas).conditions(is_backup: false)
                                              .class_name("FullObjectReplica")
  }
  it {
    is_expected.to have_many(:object_backups_and_replicas).class_name("FullObjectReplica")
                                                          .dependent(:destroy)
  }
  it {
    is_expected.to have_many(:sync_source_tokens).with_foreign_key(:source_cell_volume_id)
      .class_name("SyncToken").dependent(:destroy)
  }
  it {
    is_expected.to have_many(:sync_target_tokens).with_foreign_key(:target_cell_volume_id)
      .class_name("SyncToken").dependent(:destroy)
  }

  describe "#serializable_hash" do
    subject { cell_volume.serializable_hash }

    let(:cell_volume_data) do
      {
        "partition"          => cell_volume.partition,
        "total_capacity"     => cell_volume.total_capacity,
        "available_capacity" => cell_volume.available_capacity,
        "status"             => cell_volume.status,
        "created_at"         => be_a(Time),
        "updated_at"         => be_a(Time)
      }
    end

    it { is_expected.to match cell_volume_data }
  end
end
