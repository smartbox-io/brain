class AdminApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :authenticate_admin
  before_action :admin_active?

  private

  def forbidden
    head :forbidden
  end

  def authenticate_admin
    authenticate_or_request_with_http_basic("Admin API") do |username, password|
      @admin ||= Admin.find_by(username: username).try(:authenticate, password)
    end
  end

  def admin_active?
    !@admin.inactive || forbidden
  end
end
