require "spec_helper"

RSpec.describe CellBlockDevice do

  it { is_expected.to belong_to(:cell) }
  it do
    is_expected.to have_many(:volumes).class_name("CellVolume").dependent(:destroy)
  end

end
