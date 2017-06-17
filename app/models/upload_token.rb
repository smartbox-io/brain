class UploadToken < ApplicationRecord
  include TokenGeneration

  belongs_to :user
  belongs_to :cell_volume
  has_one :cell, through: :cell_volume

  before_validation :assign_cell_volume, on: :create

  private

  def assign_cell_volume
    self.cell_volume ||= Cell.healthy.sample.volumes.sample
  end
end
