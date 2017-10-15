require "spec_helper"

RSpec.describe User do
  it { is_expected.to have_many(:refresh_tokens).dependent(:destroy) }
  it { is_expected.to have_many(:download_tokens).dependent(:destroy) }
  it { is_expected.to have_many(:objects).class_name("FullObject").dependent(:destroy) }
  it { is_expected.to have_many(:upload_tokens).dependent(:destroy) }
end
