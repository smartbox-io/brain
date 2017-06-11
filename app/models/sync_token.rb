class SyncToken < ApplicationRecord
  include TokenGeneration

  belongs_to :source_cell, class_name: "Cell"
  belongs_to :source_cell_volume, class_name: "CellVolume"
  belongs_to :target_cell, class_name: "Cell"
  belongs_to :target_cell_volume, class_name: "CellVolume"
  belongs_to :object, class_name: "FullObject"

  enum status: [:scheduled, :syncing, :done]
end
