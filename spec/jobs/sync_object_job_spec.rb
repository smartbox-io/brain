require "spec_helper"

RSpec.describe SyncObjectJob do

  let(:sync_token) { FactoryBot.create :sync_token }

  describe "#perform" do
    it "calls to Brain.sync_object" do
      allow(Brain).to receive(:sync_object).with sync_token: sync_token
      described_class.perform_now sync_token: sync_token
      expect(Brain).to have_received(:sync_object).with(sync_token: sync_token).once
    end
  end

end
