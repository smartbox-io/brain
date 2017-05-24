class User < ApplicationRecord
  has_secure_password

  has_many :full_objects
  has_many :download_tokens
  has_many :upload_tokens
end
