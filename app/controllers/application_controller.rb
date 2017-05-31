class ApplicationController < ActionController::API

  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :load_jwt

  private

  def ok
    head :ok
  end

  def forbidden
    head :forbidden
  end

  def not_found
    head :not_found
  end

  def load_jwt
    jwt = authenticate_or_request_with_http_token do |jwt, options|
      JWTUtils.decode jwt: jwt
    end
    @user_id = jwt[:payload][:user_id]
  end

  def current_user
    @user ||= User.find @user_id
  end

end
