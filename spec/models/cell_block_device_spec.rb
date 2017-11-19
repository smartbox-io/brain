require "spec_helper"

RSpec.describe CellBlockDevice do

  it { is_expected.to belong_to(:cell) }
  it do
    is_expected.to have_many(:partitions).class_name("CellBlockDevicePartition").dependent(:destroy)
  end

end
