module TokenGeneration
  extend ActiveSupport::Concern

  included do
    before_create :__generate_token
  end

  def __generate_token
    self.token ||= SecureRandom.hex 64
  end
end
