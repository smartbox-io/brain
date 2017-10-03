class FullObjectReplica < ApplicationRecord
  belongs_to :object, class_name: "FullObject", foreign_key: :full_object_id
  belongs_to :cell_volume
  has_one :cell, through: :cell_volume

  enum status: %i[scheduled syncing healthy marked_for_deletion deleting]
end
