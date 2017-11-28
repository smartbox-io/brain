class CellBlockDevice < ApplicationRecord
  belongs_to :cell
  has_many :volumes, class_name: "CellVolume", dependent: :destroy

  enum status: %i[discovered accepted]
end
