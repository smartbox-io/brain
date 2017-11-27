require "spec_helper"
require "cli"

RSpec.describe AdminCLI do

  subject(:admin_cli) { described_class.new }

  let(:admin) { FactoryBot.create :admin }
  let(:username) { "username" }
  let(:password) { "password" }
  let(:email) { "user@example.com" }
  let(:admin_params) do
    {
      path:    "/admin-api/v1/admins",
      method:  :post,
      payload: {
        admin: {
          username: username,
          email:    email,
          password: password
        }
      }

    }
  end

  before { allow(BrainAdminApi).to receive(:request).and_return [OpenStruct.new(code: 201), nil] }

  describe "#create" do
    context "when no admin user exists" do
      it "does not ask for any password" do
        allow(CLI).to receive :ask_admin_credentials
        allow(CLI).to receive(:ask_new_password).and_return password
        admin_cli.create username, email
        expect(CLI).not_to have_received :ask_admin_credentials
      end

      it "creates a first admin user" do
        allow(CLI).to receive(:ask_new_password).and_return password
        admin_cli.create username, email
        expect(BrainAdminApi).to have_received(:request).with admin_params
      end
    end

    context "when an admin user exists" do
      before { admin }

      it "asks for admin credentials" do
        allow(CLI).to receive :ask_admin_credentials
        allow(CLI).to receive(:ask_new_password).and_return password
        admin_cli.create username, email
        expect(CLI).to have_received :ask_admin_credentials
      end
    end

    context "when a password is provided" do
      it "does not ask for a new password" do
        allow(CLI).to receive :ask_new_password
        admin_cli.create username, email, password
        expect(CLI).not_to have_received :ask_new_password
      end
    end
  end

end
