class FullObjectReplica < ApplicationRecord
  belongs_to :full_object
  belongs_to :cell
  belongs_to :cell_volume

  enum status: [:scheduled, :syncing, :healthy, :marked_for_deletion, :deleting]
end
