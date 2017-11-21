class AdminApi::V1::AdminsController < AdminApplicationController
  skip_before_action :authenticate_admin, if: (lambda do |c|
    Admin.active.count.zero? && %w[create update].include?(c.action_name)
  end)

  skip_before_action :admin_active?, if: (lambda do |c|
    Admin.active.count.zero? && %w[create update].include?(c.action_name)
  end)

  def index
    ok payload: Admin.all
  end

  def create
    Admin.create! admin_params
    ok status: :created
  rescue ActiveRecord::RecordInvalid
    unprocessable_entity
  end

  def update
    # TODO
  end

  private

  def admin_params
    params.require(:admin).permit :username, :email, :password
  end
end
