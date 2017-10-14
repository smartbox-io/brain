require "rails_helper"

RSpec.describe RefreshToken do
  it { is_expected.to belong_to(:user) }
end
