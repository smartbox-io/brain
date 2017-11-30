class Cell < ApplicationRecord
  has_many :block_devices, class_name: "CellBlockDevice", dependent: :destroy
  has_many :volumes, class_name: "CellVolume", through: :block_devices
  has_many :object_backups, through: :volumes
  has_many :object_replicas, through: :volumes
  has_many :sync_source_tokens, through: :volumes
  has_many :sync_target_tokens, through: :volumes

  enum status: %i[discovered accepted healthy unhealthy]

  def accept(block_devices: [])
    return false if status != "discovered"
    update_column :status, :accepted
    accept_block_devices block_devices: block_devices
  end

  def remote
    @remote ||= CellApi.new cell: self
  end

  private

  def accept_block_devices(block_devices:)
    return true if block_devices.blank?
    response, = remote.accept_block_devices block_devices: block_devices
    if response.code == 202
      self.block_devices.where(device: block_devices).update_all(
        status: CellBlockDevice.statuses[:accepted]
      )
      return true
    end
    false
  end
end
