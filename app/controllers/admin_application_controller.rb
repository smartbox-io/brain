class AdminApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :load_admin
  before_action :admin_active?

  private

  def forbidden
    head :forbidden
  end

  def load_admin
    @admin ||= Admin.find_by! username: params[:username], password: params[:password]
  rescue ActiveRecord::RecordNotFound
    forbidden
  end

  def admin_active?
    !@admin.inactive || forbidden
  end
end
