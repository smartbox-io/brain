require "rails_helper"

RSpec.describe FullObjectTag do
  it {
    is_expected.to belong_to(:object).class_name("FullObject").with_foreign_key(:full_object_id)
  }
  it { is_expected.to belong_to(:tag) }
end
