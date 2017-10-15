require "spec_helper"

RSpec.describe UploadToken do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:cell_volume) }
  it { is_expected.to have_one(:cell).through(:cell_volume) }
end
