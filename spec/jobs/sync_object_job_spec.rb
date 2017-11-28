require "spec_helper"

RSpec.describe SyncObjectJob do

  let(:sync_token) { FactoryBot.create :sync_token }

  describe "#perform" do
    it "calls to sync_object on the sync_token" do
      allow(sync_token).to receive :sync_object
      described_class.perform_now sync_token: sync_token
      expect(sync_token).to have_received(:sync_object).once
    end
  end

end
