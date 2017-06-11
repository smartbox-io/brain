class JWTUtils

  def self.encode(payload:, expires_in: 1.hour, version: :v1)
    return JWT.encode({
                        payload: payload,
                        expiration: expires_in.from_now.to_i,
                        version: version
                      }, Rails.application.secrets.secret_key_base), expires_in.to_i
  end

  def self.decode(jwt:)
    payload, _ =  JWT.decode jwt, Rails.application.secrets.secret_key_base
    HashWithIndifferentAccess.new payload
  end

end
