class ClusterApi::V1::DownloadTokensController < ClusterApplicationController

  def show
    current_user.download_tokens.find_by! token: params[:token],
                                          cell: @cell,
                                          remote_ip: params[:client_ip]
    ok
  rescue ActiveRecord::RecordNotFound
    forbidden
  end

end
