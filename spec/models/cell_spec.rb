require "spec_helper"

RSpec.describe Cell do
  it { is_expected.to have_many(:volumes).class_name("CellVolume").dependent(:destroy) }
  it { is_expected.to have_many(:object_backups).through(:volumes) }
  it { is_expected.to have_many(:object_replicas).through(:volumes) }
  it { is_expected.to have_many(:sync_source_tokens).through(:volumes) }
  it { is_expected.to have_many(:sync_target_tokens).through(:volumes) }
  it { is_expected.to define_enum_for(:status).with(%i[discovered accepted healthy unhealthy]) }
end
