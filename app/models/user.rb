class User < ApplicationRecord
  has_secure_password

  has_many :refresh_tokens, dependent: :destroy
  has_many :download_tokens, dependent: :destroy
  has_many :objects, class_name: "FullObject", dependent: :destroy
  has_many :upload_tokens, dependent: :destroy

  def access_and_refresh_tokens
    access_token, expires_in = JWTUtils.encode payload: { user_id: id }
    {
      access_token:  access_token,
      expires_in:    expires_in,
      refresh_token: refresh_tokens.create.token
    }
  end
end
