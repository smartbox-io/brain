class ClusterApi::V1::UploadTokensController < ClusterApplicationController

  def show
    current_user.upload_tokens.find_by! token: params[:token],
                                        cell: @cell,
                                        remote_ip: params[:client_ip]
  rescue ActiveRecord::RecordNotFound
    forbidden
  end

end
