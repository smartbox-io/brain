class ClusterApi::V1::Cells::BlockDevicesController < ClusterTokenlessApplicationController
  def update
    block_devices_params[:block_devices].each do |block_device|
      @cell.block_devices.where(device: block_device[:device]).update_all(
        status: block_device[:status]
      )
      block_device[:volumes].each do |volume|
        @cell.volumes.where(volume: volume[:volume]).update_all status: volume[:status]
      end
    end
    ok
  end

  private

  def block_devices_params
    params.require(:cell).permit block_devices: [:device, :status, volumes: %i[volume status]]
  end
end
