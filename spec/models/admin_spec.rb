require "spec_helper"

RSpec.describe Admin do
  it { is_expected.to have_secure_password }
end
