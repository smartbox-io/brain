require "spec_helper"

RSpec.describe UploadToken do
  let(:upload_token) { FactoryBot.create :upload_token }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:cell_volume) }
  it { is_expected.to have_one(:cell).through(:cell_volume) }

  it "assigns a cell volume upon creation" do
    expect(upload_token.cell_volume).not_to be_nil
  end
end
