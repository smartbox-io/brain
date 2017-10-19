require "spec_helper"

RSpec.describe User do
  let(:user) { FactoryGirl.create :user }

  it { is_expected.to have_many(:refresh_tokens).dependent(:destroy) }
  it { is_expected.to have_many(:download_tokens).dependent(:destroy) }
  it { is_expected.to have_many(:objects).class_name("FullObject").dependent(:destroy) }
  it { is_expected.to have_many(:upload_tokens).dependent(:destroy) }

  describe "#access_and_refresh_tokens" do
    subject { user.access_and_refresh_tokens }

    it { is_expected.to include(:access_token, :expires_in, :refresh_token) }
  end
end
