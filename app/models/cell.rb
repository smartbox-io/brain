class Cell < ApplicationRecord
  has_many :block_devices, class_name: "CellBlockDevice", dependent: :destroy
  has_many :volumes, class_name: "CellVolume", through: :block_devices
  has_many :object_backups, through: :volumes
  has_many :object_replicas, through: :volumes
  has_many :sync_source_tokens, through: :volumes
  has_many :sync_target_tokens, through: :volumes

  enum status: %i[discovered accepted healthy unhealthy]

  def accept(volumes:)
    return false if status != "discovered"
    remote.accept volumes: volumes
    update_column :status, :accepted
  end

  def remote
    @remote ||= CellApi.new cell: self
  end
end
