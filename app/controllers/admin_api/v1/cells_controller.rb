class AdminApi::V1::CellsController < AdminApplicationController
  def index
    ok payload: Cell.all
  end
end
