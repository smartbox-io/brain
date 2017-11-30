class AdminApi::V1::Cells::AcceptController < AdminApplicationController
  def create
    cell = Cell.find_by! uuid: params[:uuid]
    if cell.accept block_devices: block_devices_params[:block_devices]
      head :ok
    else
      forbidden
    end
  end

  private

  def block_devices_params
    params.require(:cell).permit block_devices: []
  end
end
