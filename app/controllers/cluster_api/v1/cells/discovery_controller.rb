class ClusterApi::V1::Cells::DiscoveryController < ClusterTokenlessApplicationController

  skip_before_action :load_cell, only: :create

  def create
    cell = Cell.find_or_create_by(uuid: discovery_params[:uuid]) do |cell|
      cell.fqdn = discovery_params[:fqdn]
      cell.ip_address = request.remote_ip
      cell.status = :discovered
    end
    render json: {
             cell: {
               uuid: cell.uuid,
               fqdn: cell.fqdn,
               ip_address: cell.ip_address
             }
           }
  end

  private

  def discovery_params
    params.require(:cell).permit(:uuid, :fqdn)
  end

end
