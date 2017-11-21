class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :load_jwt

  private

  def ok(payload: nil, status: :ok)
    if payload
      render json: payload, status: status
    else
      head status
    end
  end

  def unprocessable_entity
    head :unprocessable_entity
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
