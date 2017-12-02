require "spec_helper"

RSpec.describe Admin do
  let(:admin) { FactoryBot.create :admin }

  it { is_expected.to have_secure_password }

  describe "#serializable_hash" do
    subject { admin.serializable_hash }

    let(:admin_data) do
      {
        "username"   => admin.username,
        "email"      => admin.email,
        "inactive"   => admin.inactive,
        "created_at" => be_a(Time),
        "updated_at" => be_a(Time)
      }
    end

    it { is_expected.to match admin_data }
  end
end
