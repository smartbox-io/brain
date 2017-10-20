class Api::V1::Objects::DownloadsController < ApplicationController
  before_action :load_object

  def show
    download_token = current_user.download_tokens.create object:    @object,
                                                         remote_ip: request.remote_ip

    render json: {
      download_token: download_token.token,
      cell:           {
        ip_address: download_token.cell.public_ip_address
      }
    }
  end

  private

  def load_object
    @object = FullObject.find_by! uuid: params[:uuid]
  rescue ActiveRecord::RecordNotFound
    not_found
  end
end
