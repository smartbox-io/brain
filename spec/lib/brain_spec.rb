require "spec_helper"
require "brain"

RSpec.describe Brain do

  let(:object) { FactoryGirl.create :full_object }
  let(:volume) { FactoryGirl.create :cell_volume }
  let(:other_volume) { FactoryGirl.create :cell_volume }
  let(:sync_token) { FactoryGirl.create :sync_token }

  describe ".schedule_sync" do
    def schedule_sync
      described_class.schedule_sync object: object, source_volume: volume,
                                    target_volume: other_volume
    end

    it "creates a sync token" do
      expect { schedule_sync }.to change { SyncToken.count }.by 1
    end

    it "schedules a SyncObjectJob" do
      expect { schedule_sync }.to have_enqueued_job SyncObjectJob
    end

    context "when creating the sync token" do
      subject { SyncToken.last }

      before { schedule_sync }

      it { is_expected.to have_attributes status: "scheduled" }
    end
  end

  describe ".converge_object" do
    let(:params) do
      {
        object:        object,
        source_volume: anything,
        target_volume: other_volume
      }
    end

    def converge_object
      described_class.converge_object object: object
    end

    context "when the desired replica number is not met" do
      before do
        allow(object).to receive(:desired_replica_number).and_return 2
        allow(object).to receive(:current_replica_number).and_return 1
      end

      it "schedules a sync" do
        allow(described_class).to receive(:schedule_sync).with params
        converge_object
        expect(described_class).to have_received(:schedule_sync).with(params).once
      end
    end
  end

  describe ".sync_object" do
    let(:request_params) do
      {
        path:    "/cluster-api/v1/objects",
        method:  :post,
        payload: {
          sync_token: sync_token.token
        }
      }
    end

    def sync_object
      described_class.sync_object sync_token: sync_token
    end

    it "makes a request to the target cell" do
      allow(sync_token.target_cell).to receive(:request).with(request_params)
      sync_object
      expect(sync_token.target_cell).to have_received(:request).with(request_params)
    end
  end

end
