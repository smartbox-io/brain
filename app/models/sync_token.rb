class SyncToken < ApplicationRecord
  include TokenGeneration

  belongs_to :source_cell_volume, class_name: "CellVolume"
  has_one :source_cell, through: :source_cell_volume, source: :cell
  belongs_to :target_cell_volume, class_name: "CellVolume"
  has_one :target_cell, through: :target_cell_volume, source: :cell
  belongs_to :object, class_name: "FullObject", foreign_key: :full_object_id

  enum status: %i[scheduled syncing done]

  def sync_object
    target_cell.remote.sync_object sync_token: self
  end
end
