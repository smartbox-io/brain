class SyncToken < ApplicationRecord
  include TokenGeneration

  belongs_to :source_cell, class_name: "Cell"
  belongs_to :target_cell, class_name: "Cell"
  belongs_to :full_object

  enum status: [:scheduled, :syncing, :ok]
end
