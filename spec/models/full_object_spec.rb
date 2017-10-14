require "rails_helper"

RSpec.describe FullObject do
  it { is_expected.to belong_to(:user) }
  it {
    is_expected.to have_many(:backups).conditions(is_backup: true)
                                      .class_name("FullObjectReplica")
  }
  it {
    is_expected.to have_many(:replicas).conditions(is_backup: false)
                                       .class_name("FullObjectReplica")
  }
  it {
    is_expected.to have_many(:backups_and_replicas).class_name("FullObjectReplica")
                                                   .dependent(:destroy)
  }
  it { is_expected.to have_many(:cell_volumes).through(:backups_and_replicas) }
  it { is_expected.to have_many(:cells).through(:cell_volumes) }
  it { is_expected.to validate_numericality_of(:backup_size).only_integer }
  it { is_expected.to validate_numericality_of(:replica_size).only_integer }
end
