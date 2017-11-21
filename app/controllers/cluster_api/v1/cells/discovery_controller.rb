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
    params[:cell][:block_devices].each do |device, device_information|
      cell.block_devices.find_or_initialize_by(device: device).tap do |device_|
        device_.total_capacity = device_information[:total_capacity]
      end.save
      consolidate_volumes cell:               cell,
                          device:             device,
                          device_information: device_information
    end
  end

  def consolidate_volumes(cell:, device:, device_information:)
    device_information[:partitions].each do |partition, partition_information|
      device_ = cell.block_devices.find_by device: device
      device_.volumes.find_or_initialize_by(partition: partition).tap do |volume|
        volume.total_capacity = partition_information[:total_capacity]
      end.save
    end
  end
end
