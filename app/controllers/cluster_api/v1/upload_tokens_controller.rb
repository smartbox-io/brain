class ClusterApi::V1::UploadTokensController < ClusterApplicationController

  def show
    token = current_user.upload_tokens.find_by! token: params[:token],
                                                cell: @cell,
                                                remote_ip: params[:client_ip]
    ok payload: {
         volume: token.cell_volume.mountpoint
       }
  rescue ActiveRecord::RecordNotFound
    forbidden
  end

  def destroy
    current_user.upload_tokens.destroy_all token: params[:token],
                                           cell: @cell
    ok
  rescue ActiveRecord::RecordNotFound
    not_found
  end

end
