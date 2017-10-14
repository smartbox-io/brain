require "rails_helper"

RSpec.describe FullObjectReplica do
  it {
    is_expected.to belong_to(:object).class_name("FullObject")
                                     .with_foreign_key(:full_object_id)
  }
  it { is_expected.to belong_to(:cell_volume) }
  it { is_expected.to have_one(:cell).through(:cell_volume) }
  it {
    is_expected.to define_enum_for(:status).with(%i[scheduled syncing healthy marked_for_deletion
                                                    deleting])
  }
end
