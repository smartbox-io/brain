require "spec_helper"
require "cli"

RSpec.describe AdminCLI do

  subject(:admin_cli) { described_class.new }

  let(:admin) { FactoryBot.create :admin }
  let(:username) { "username" }
  let(:password) { "password" }
  let(:email) { "user@example.com" }

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
        expect { admin_cli.create(username, email) }.to change { Admin.count }.by 1
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
  end

end
