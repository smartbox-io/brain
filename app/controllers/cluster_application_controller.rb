class ClusterApplicationController < ApplicationController
  before_action :load_cell

  private

  def load_cell
    @cell = Cell.find_by! ip_address: request.remote_ip
  rescue ActiveRecord::RecordNotFound
    forbidden
  end
end
