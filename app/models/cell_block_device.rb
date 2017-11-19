class CellBlockDevice < ApplicationRecord
  belongs_to :cell
  has_many :partitions, class_name: "CellBlockDevicePartition", dependent: :destroy
end
