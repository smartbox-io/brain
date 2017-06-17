class ClusterApi::V1::Cells::DiscoveryController < ClusterTokenlessApplicationController

  skip_before_action :load_cell, only: :create

  def create
    cell = Cell.find_or_initialize_by(uuid: params[:cell][:uuid]) do |cell|
      cell.status = :discovered
    end
    cell.tap do |cell|
      cell.fqdn = params[:cell][:fqdn]
      cell.ip_address = request.remote_ip
      cell.public_ip_address = params[:cell][:public_ip_address]
    end.save
    params[:cell][:volumes].each do |mountpoint, volume_information|
      cell.volumes.find_or_initialize_by(mountpoint: mountpoint).tap do |volume|
        volume.total_capacity = volume_information[:total_capacity]
        volume.available_capacity = volume_information[:available_capacity]
      end.save
    end
    render json: {
             cell: {
               uuid: cell.uuid,
               fqdn: cell.fqdn,
               ip_address: cell.ip_address,
               public_ip_address: cell.public_ip_address
             }
           }
  end

end
