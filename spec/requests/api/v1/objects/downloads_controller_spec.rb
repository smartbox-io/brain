require "spec_helper"

RSpec.describe Api::V1::Objects::DownloadsController do
  subject { response }

  let(:object_replica) { FactoryBot.create :full_object_replica }
  let(:user) { object_replica.object.user }

  describe "#show" do
    context "with an existing object" do
      before { get api_v1_download_path(object_replica.object.uuid), headers: token_auth(user) }

      it { is_expected.to have_http_status :ok }
    end

    context "with a non existing object" do
      before { get api_v1_download_path(SecureRandom.uuid), headers: token_auth(user) }

      it { is_expected.to have_http_status :not_found }
    end

    context "when the download token cannot be created" do
      before do
        stub_current_user user
        allow(user.download_tokens).to receive(:create!).and_raise ActiveRecord::RecordInvalid
        get api_v1_download_path(object_replica.object.uuid), headers: token_auth(user)
      end

      it { is_expected.to have_http_status :unprocessable_entity }
    end
  end
end
