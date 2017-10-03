class Api::V1::Objects::DownloadsController < ApplicationController
  def show
    download_token = current_user.download_tokens.create remote_ip: request.remote_ip
    render json: {
      download_token: download_token.token,
      cell:           {
        ip_address: download_token.cell.public_ip_address
      }
    }
  end
end
