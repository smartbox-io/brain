class UploadToken < ApplicationRecord
  include TokenGeneration

  belongs_to :full_object, optional: true
  belongs_to :user
  belongs_to :cell
  belongs_to :cell_volume

  before_validation :assign_cell, on: :create
  before_validation :assign_cell_volume, on: :create

  private

  def assign_cell
    self.cell ||= Cell.healthy.sample
  end

  def assign_cell_volume
    self.cell_volume ||= self.cell.volumes.first
  end
end
