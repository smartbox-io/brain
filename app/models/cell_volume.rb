class CellVolume < ApplicationRecord
  belongs_to :cell

  has_many :object_backups, -> { where is_backup: true }, class_name: "FullObjectReplica"
  has_many :object_replicas, -> { where is_backup: false }, class_name: "FullObjectReplica"
  has_many :object_backups_and_replicas, class_name: "FullObjectReplica", dependent: :destroy
  has_many :sync_source_tokens, foreign_key: :source_cell_volume_id, class_name: "SyncToken",
           dependent: :destroy
  has_many :sync_target_tokens, foreign_key: :target_cell_volume_id, class_name: "SyncToken",
           dependent: :destroy

  scope :cell_healthy, -> { cell_status :healthy }
  scope :cell_status, ->(status) { includes(:cell).where cells: { status: status } }
end
