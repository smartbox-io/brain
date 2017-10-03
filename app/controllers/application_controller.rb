class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :load_jwt

  private

  def ok(payload: nil)
    if payload
      render json: payload, status: :ok
    else
      head :ok
    end
  end

  def forbidden
    head :forbidden
  end

  def not_found
    head :not_found
  end

  def load_jwt
    jwt = authenticate_or_request_with_http_token do |jwt_, _|
      JWTUtils.decode jwt: jwt_
    end
    @user_id = jwt[:payload][:user_id]
  end

  def current_user
    @user ||= User.find @user_id
  end
end
