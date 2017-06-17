class DownloadToken < ApplicationRecord
  include TokenGeneration

  belongs_to :object, class_name: "FullObject", foreign_key: :full_object_id
  belongs_to :user
  belongs_to :cell_volume
  has_one :cell, through: :cell_volume
end
