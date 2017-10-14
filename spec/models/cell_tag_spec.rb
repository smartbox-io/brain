require "rails_helper"

RSpec.describe CellTag do
  it { is_expected.to belong_to(:cell) }
  it { is_expected.to belong_to(:tag) }
end
