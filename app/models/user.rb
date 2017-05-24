class User < ApplicationRecord
  has_secure_password

  has_many :refresh_tokens, dependent: :destroy
  has_many :download_tokens, dependent: :destroy
  has_many :full_objects, dependent: :destroy
  has_many :upload_tokens, dependent: :destroy
end
