class FullObjectReplica < ApplicationRecord
  belongs_to :object, class_name: "FullObject"
  belongs_to :cell
  belongs_to :cell_volume

  enum status: [:scheduled, :syncing, :healthy, :marked_for_deletion, :deleting]
end
