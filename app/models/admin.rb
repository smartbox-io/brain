class Admin < ApplicationRecord
  has_secure_password

  scope :active, -> { where inactive: false }

  def serializable_hash(options = nil)
    super (options || {}).merge(except: %i[id password_digest])
  end
end
