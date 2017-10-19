require "spec_helper"

RSpec.describe Api::V1::Objects::DownloadsController do
  subject { response }

  let(:object_replica) { FactoryGirl.create :full_object_replica }
  let(:user) { object_replica.object.user }

  describe "#show" do
    before { get api_v1_download_path(object_replica.object.uuid), headers: token_auth(user) }

    it { is_expected.to have_http_status :ok }
  end
end
