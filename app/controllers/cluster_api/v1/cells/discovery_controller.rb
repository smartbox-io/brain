class ClusterApi::V1::Cells::DiscoveryController < ClusterTokenlessApplicationController
  skip_before_action :load_cell, only: :create

  # rubocop:disable Metrics/MethodLength
  def create
    cell = Cell.find_or_initialize_by(uuid: params[:cell][:uuid]) do |cell_|
      cell_.status = :discovered
    end
    consolidate_cell cell: cell
    consolidate_block_devices cell: cell
    ok payload: {
      cell: {
        uuid:              cell.uuid,
        fqdn:              cell.fqdn,
        ip_address:        cell.ip_address,
        public_ip_address: cell.public_ip_address
      }
    }
  end
  # rubocop:enable Metrics/MethodLength

  private

  def consolidate_cell(cell:)
    cell.tap do |cell_|
      cell_.fqdn = params[:cell][:fqdn]
      cell_.ip_address = request.remote_ip
      cell_.public_ip_address = params[:cell][:public_ip_address]
    end.save
  end

  def consolidate_block_devices(cell:)
    params[:cell][:block_devices].each do |block_device|
      cell.block_devices.find_or_initialize_by(device: block_device[:device]).tap do |device_|
        device_.total_capacity = block_device[:total_capacity]
      end.save
      consolidate_volumes cell: cell, block_device: block_device
    end
  end

  def consolidate_volumes(cell:, block_device:)
    block_device[:volumes].each do |volume|
      device_ = cell.block_devices.find_by device: block_device[:device]
      device_.volumes.find_or_initialize_by(volume: volume[:volume]).tap do |volume_|
        volume_.total_capacity = volume[:total_capacity]
      end.save
    end
  end
end
