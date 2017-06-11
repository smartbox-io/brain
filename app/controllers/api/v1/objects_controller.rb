class Api::V1::ObjectsController < ApplicationController

  before_action :load_object, except: :create

  def show
    render json: {
             uuid: @object.uuid,
             name: @object.name,
             size: @object.size
           }
  end

  def create
    upload_token = current_user.upload_tokens.create remote_ip: request.remote_ip
    render json: {
             upload_token: upload_token.token,
             cell: {
               ip_address: upload_token.cell.public_ip_address
             }
           }
  end

  def destroy
  end

  private

  def load_object
    @object = current_user.full_objects.find_by uuid: params[:uuid]
  end

end
