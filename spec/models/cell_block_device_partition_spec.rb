require "spec_helper"

RSpec.describe CellBlockDevicePartition do

  it { is_expected.to belong_to(:cell_block_device) }

end
