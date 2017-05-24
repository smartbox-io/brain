class RefreshToken < ApplicationRecord
  belongs_to :user
  before_create :generate_refresh_token

  private

  def generate_refresh_token
    self.token ||= SecureRandom.hex 64
  end
end
