require "spec_helper"

RSpec.describe DownloadToken do
  it {
    is_expected.to belong_to(:object).class_name("FullObject")
                                     .with_foreign_key(:full_object_id)
  }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:cell_volume) }
  it { is_expected.to have_one(:cell).through(:cell_volume) }
end
