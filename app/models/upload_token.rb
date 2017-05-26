class UploadToken < ApplicationRecord
  include TokenGeneration

  belongs_to :full_object, optional: true
  belongs_to :user
  belongs_to :cell

  before_create :assign_cell

  private

  def assign_cell
    self.cell = Cell.all.sample
  end
end
