class Cell < ApplicationRecord
  has_many :volumes, class_name: "CellVolume", dependent: :destroy
  has_many :full_object_backups, -> { where is_backup: true }, class_name: "FullObjectReplica", dependent: :destroy
  has_many :full_object_replicas, -> { where is_backup: false }, dependent: :destroy
  has_many :sync_source_tokens, foreign_key: :source_cell_id, class_name: "SyncToken", dependent: :destroy
  has_many :sync_target_tokens, foreign_key: :target_cell_id, class_name: "SyncToken", dependent: :destroy

  enum status: [:discovered, :healthy, :unhealthy]
end
