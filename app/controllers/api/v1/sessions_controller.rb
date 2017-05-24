class Api::V1::SessionsController < ApplicationController

  before_action :load_jwt, only: %i(update destroy)

  rescue_from ActiveRecord::RecordNotFound, with: :forbidden

  def create
    user = User.find_by username: params[:username]
    if user.try :authenticate, params[:password]
      render_access_token user: user
    else
      head :forbidden
    end
  end

  def update
    if @user.refresh_tokens.where(token: params[:refresh_token]).delete_all == 1
      render_access_token user: @user
    else
      head :forbidden
    end
  end

  def destroy
    if @user.refresh_tokens.where(token: params[:refresh_token]).delete_all == 1
      head :ok
    else
      head :forbidden
    end
  end

  private

  def load_jwt
    jwt = authenticate_or_request_with_http_token do |jwt, options|
      JWTUtils.decode jwt: jwt
    end
    @user = User.find jwt[:payload][:user_id]
  end

  def render_access_token(user:)
    access_token, expires_in = JWTUtils.encode payload: { user_id: user.id }
    refresh_token = user.refresh_tokens.create
    render json: {
             access_token: access_token,
             expires_in: expires_in,
             refresh_token: refresh_token.token
           }
  end

end
