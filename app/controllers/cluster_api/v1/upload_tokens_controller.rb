class ClusterApi::V1::UploadTokensController < ClusterApplicationController
  def show
    token = current_user.upload_tokens.find_by! token:       params[:token],
                                                cell_volume: @cell.volumes,
                                                remote_ip:   params[:client_ip]
    ok payload: {
      volume: token.cell_volume.partition
    }
  rescue ActiveRecord::RecordNotFound
    forbidden
  end
end
