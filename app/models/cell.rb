class Cell < ApplicationRecord
  has_many :full_object_backups, -> { where is_backup: true }, class_name: "FullObjectReplica"
  has_many :full_object_replicas, -> { where is_backup: false }
  has_many :sync_source_tokens, foreign_key: :source_cell_id, class_name: "SyncToken"
  has_many :sync_target_tokens, foreign_key: :target_cell_id, class_name: "SyncToken"
end
