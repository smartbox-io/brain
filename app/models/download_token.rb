class DownloadToken < ApplicationRecord
  include TokenGeneration

  belongs_to :object, class_name: "FullObject"
  belongs_to :user
  belongs_to :cell
  belongs_to :cell_volume
end
