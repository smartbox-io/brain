class DownloadToken < ApplicationRecord
  include TokenGeneration

  belongs_to :object, class_name: "FullObject", foreign_key: :full_object_id
  belongs_to :user
  belongs_to :cell_volume
  has_one :cell, through: :cell_volume

  before_validation :assign_cell_volume, on: :create

  private

  def assign_cell_volume
    self.cell_volume ||= object.cell_volumes.cell_healthy.sample
  end
end
