class AdminApi::V1::Cells::AcceptController < AdminApplicationController

  def update
    cell = Cell.find_by! uuid: params[:uuid]
    if cell.accept
      head :ok
    else
      forbidden
    end
  end

end
