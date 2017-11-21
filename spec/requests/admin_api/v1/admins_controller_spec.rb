require "spec_helper"

RSpec.describe AdminApi::V1::AdminsController do
  subject { response }

  let(:admin)        { FactoryBot.create :admin }
  let(:admin_data)   do
    {
      username:   admin.username,
      email:      admin.email,
      inactive:   admin.inactive,
      created_at: a_string_starting_with(Date.today.to_s),
      updated_at: a_string_starting_with(Date.today.to_s)
    }
  end
  let(:admin_auth)   { basic_auth admin }
  let(:admin_params) do
    {
      admin: {
        username: "test",
        email:    "test@example.com",
        password: "test"
      }
    }
  end

  describe "#index" do
    before { get admin_api_v1_admins_path, headers: admin_auth }

    it { is_expected.to have_http_status :ok }

    it "lists all admin users" do
      expect(json).to match [admin_data]
    end
  end

  describe "#create" do
    def create
      post admin_api_v1_admins_path, params: admin_params
    end

    context "when no admin users exist" do
      it "creates the admin user without authentication" do
        expect { create }.to change { Admin.count }.by 1
      end
    end

    context "when the admin user cannot be created" do
      before do
        allow(Admin).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
        create
      end

      it { is_expected.to have_http_status :unprocessable_entity }
    end
  end

  describe "#update" do
    it "should update an admin user"
  end
end
