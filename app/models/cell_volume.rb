class CellVolume < ApplicationRecord
  belongs_to :cell

  scope :cell_healthy, -> { cell_status :healthy }
  scope :cell_status, -> (status) { includes(:cell).where cells: { status: status } }
end
