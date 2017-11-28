class AdminApi::V1::Cells::AcceptController < AdminApplicationController
  def create
    cell = Cell.find_by! uuid: params[:uuid]
    if cell.accept volumes: volumes_params[:volumes]
      head :ok
    else
      forbidden
    end
  end

  private

  def volumes_params
    params.require(:cell).permit volumes: []
  end
end
