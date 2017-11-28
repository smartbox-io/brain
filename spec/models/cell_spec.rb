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

  describe "#accept" do
    subject { cell.accept volumes: [] }

    before do
      allow(cell.remote).to receive(:accept).with(volumes: [])
    end

    context "current status is discovered" do
      let(:cell) { FactoryBot.create :cell, status: described_class.statuses[:discovered] }

      it { is_expected.to be true }

      it "sets the cell in accepted status" do
        expect { cell.accept volumes: [] }.to change { cell.reload.status }.from("discovered")
                                                                           .to("accepted")
      end
    end

    (described_class.statuses.keys - ["discovered"]).each do |status|
      context "current status is #{status}" do
        let(:cell) { FactoryBot.create :cell, status: status }

        it { is_expected.to be false }

        it "does not change cell status" do
          expect { cell.accept(volumes: []) }.not_to(change { cell.reload.status })
        end
      end
    end
  end
end
