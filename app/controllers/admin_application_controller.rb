class AdminApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :authenticate_admin
  before_action :admin_active?

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

  def authenticate_admin
    authenticate_or_request_with_http_basic("Admin API") do |username, password|
      @admin ||= Admin.find_by(username: username).try(:authenticate, password)
    end
  end

  def admin_active?
    forbidden if @admin.inactive
  end
end
