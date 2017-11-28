require "spec_helper"

RSpec.describe SyncToken do
  it { is_expected.to belong_to(:source_cell_volume).class_name("CellVolume") }
  it { is_expected.to have_one(:source_cell).through(:source_cell_volume).source(:cell) }
  it { is_expected.to belong_to(:target_cell_volume).class_name("CellVolume") }
  it { is_expected.to have_one(:target_cell).through(:target_cell_volume).source(:cell) }
  it {
    is_expected.to belong_to(:object).class_name("FullObject").with_foreign_key(:full_object_id)
  }
  it { is_expected.to define_enum_for(:status).with(%i[scheduled syncing done]) }

  describe ".sync_object" do
    subject { target_cell_remote }

    let(:sync_token)         { FactoryBot.create :sync_token }
    let(:target_cell_remote) { sync_token.target_cell.remote }

    before do
      allow(target_cell_remote).to receive(:sync_object).with sync_token: sync_token
      sync_token.sync_object
    end

    it { is_expected.to have_received(:sync_object).once.with sync_token: sync_token }
  end

end
