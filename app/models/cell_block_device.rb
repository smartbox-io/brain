class CellBlockDevice < ApplicationRecord
  belongs_to :cell
  has_many :volumes, class_name: "CellVolume", dependent: :destroy

  enum status: %i[discovered accepted healthy unhealthy]

  def serializable_hash(options = nil)
    super (options || {}).merge except: %i[id cell_id], include: %i[volumes]
  end
end
