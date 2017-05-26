module TokenGeneration
  extend ActiveSupport::Concern

  included do
    before_create :__generate_token
  end

  def __generate_token
    self.token ||= SecureRanom.hex 64
  end
end
