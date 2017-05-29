class FullObjectReplica < ApplicationRecord
  belongs_to :full_object
  belongs_to :cell

  enum status: [:scheduled, :syncing, :healthy, :marked_for_deletion, :deleting]
end
