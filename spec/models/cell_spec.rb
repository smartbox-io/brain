require "spec_helper"

RSpec.describe Cell do
  let(:cell) { FactoryBot.create :cell }

  it { is_expected.to have_many(:block_devices).class_name("CellBlockDevice").dependent(:destroy) }
  it { is_expected.to have_many(:volumes).class_name("CellVolume").through(:block_devices) }
  it { is_expected.to have_many(:object_backups).through(:volumes) }
  it { is_expected.to have_many(:object_replicas).through(:volumes) }
  it { is_expected.to have_many(:sync_source_tokens).through(:volumes) }
  it { is_expected.to have_many(:sync_target_tokens).through(:volumes) }
  it { is_expected.to define_enum_for(:status).with(%i[discovered accepted healthy unhealthy]) }

  describe "#accept without block devices" do
    subject { cell.accept block_devices: [] }

    context "current status is discovered" do
      let(:cell) { FactoryBot.create :cell, status: described_class.statuses[:discovered] }

      it { is_expected.to be true }

      it "sets the cell in accepted status" do
        expect { cell.accept block_devices: [] }.to change { cell.reload.status }.from("discovered")
                                                                                 .to("accepted")
      end
    end

    (described_class.statuses.keys - ["discovered"]).each do |status|
      context "current status is #{status}" do
        let(:cell) { FactoryBot.create :cell, status: status }

        it { is_expected.to be false }

        it "does not change cell status" do
          expect { cell.accept(block_devices: []) }.not_to(change { cell.reload.status })
        end
      end
    end
  end

  describe "#accept with block devices" do
    subject { acceptance }

    let(:cell)       { FactoryBot.create :cell, status: described_class.statuses[:discovered] }
    let(:acceptance) { cell.accept block_devices: cell.block_devices.pluck(:device) }

    context "correct callback to the cell" do
      before do
        allow(cell.remote).to receive(:accept_block_devices).and_return(
          [OpenStruct.new(code: 202), nil]
        )
      end

      it { is_expected.to be true }

      it "updates the block devices statuses" do
        expect { acceptance }.to(change { cell.block_devices.accepted.reload.count })
      end
    end

    context "error on the callback to the cell" do
      before do
        allow(cell.remote).to receive(:accept_block_devices).and_return(
          [OpenStruct.new(code: 500), nil]
        )
      end

      it { is_expected.to be false }
    end
  end
end
