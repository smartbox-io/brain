class Api::V1::SessionsController < ApplicationController
  skip_before_action :load_jwt, only: :create

  rescue_from ActiveRecord::RecordNotFound, with: :forbidden

  def create
    user = User.find_by username: params[:username]
    if user.try :authenticate, params[:password]
      render_access_token user: user
    else
      forbidden
    end
  end

  def update
    if current_user.refresh_tokens.where(token: params[:refresh_token]).delete_all == 1
      render_access_token user: current_user
    else
      forbidden
    end
  end

  def destroy
    if current_user.refresh_tokens.where(token: params[:refresh_token]).delete_all == 1
      head :ok
    else
      forbidden
    end
  end

  private

  def render_access_token(user:)
    render json: user.access_and_refresh_tokens
  end
end
