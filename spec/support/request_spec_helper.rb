module RequestSpecHelper
  def basic_auth(user)
    {
      HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(
        user.username,
        "password"
      )
    }
  end

  def token_auth(user)
    access_token = user.access_and_refresh_tokens
    {
      AUTHORIZATION: "Bearer #{access_token[:access_token]}"
    }
  end

  def ip(ip)
    { REMOTE_ADDR: ip }
  end

  # rubocop:disable RSpec/AnyInstance
  def stub_current_user(user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return user
  end
  # rubocop:enable RSpec/AnyInstance
end
