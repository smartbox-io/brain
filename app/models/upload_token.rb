class UploadToken < ApplicationRecord
  include TokenGeneration

  belongs_to :full_object, optional: true
  belongs_to :user
  belongs_to :cell

  before_validation :assign_cell, on: :create

  private

  def assign_cell
    self.cell ||= Cell.healthy.sample
  end
end
