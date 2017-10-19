require "spec_helper"

RSpec.describe Api::V1::ObjectsController do
  subject { response }

  let(:object_replica) { FactoryGirl.create :full_object_replica }
  let(:object) { object_replica.object }
  let(:user) { object.user }

  describe "#show" do
    before { get api_v1_object_path(object.uuid), headers: token_auth(user) }

    it { is_expected.to have_http_status :ok }

    it "renders object information" do
      expect(json).to include(:uuid, :name, :size)
    end
  end

  describe "#create" do
    before { post api_v1_objects_path, headers: token_auth(user) }

    it { is_expected.to have_http_status :ok }

    it "renders upload token information" do
      expect(json).to include(:upload_token, :cell)
    end
  end

  describe "#destroy" do
    it "should destroy an object"
  end
end
