require "rails_helper"

RSpec.describe CellVolume do
  it {
    is_expected.to have_many(:object_backups).conditions(is_backup: true)
                                             .class_name("FullObjectReplica")
  }
  it {
    is_expected.to have_many(:object_replicas).conditions(is_backup: false)
                                              .class_name("FullObjectReplica")
  }
  it {
    is_expected.to have_many(:object_backups_and_replicas).class_name("FullObjectReplica")
                                                          .dependent(:destroy)
  }
  it {
    is_expected.to have_many(:sync_source_tokens).with_foreign_key(:source_cell_volume_id)
      .class_name("SyncToken").dependent(:destroy)
  }
  it {
    is_expected.to have_many(:sync_target_tokens).with_foreign_key(:target_cell_volume_id)
      .class_name("SyncToken").dependent(:destroy)
  }
end
