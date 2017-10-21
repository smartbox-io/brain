require "spec_helper"

RSpec.describe FullObject do
  let(:object) { FactoryGirl.create :full_object }
  let(:object_replicas) { FactoryGirl.create_list :full_object_replica, 2, object: object }
  let(:other_cell_volume) { FactoryGirl.create :cell_volume }

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

  describe "#desired_replica_number" do
    subject { object.desired_replica_number }

    let(:max_size) { 10 }

    before do
      allow(object).to receive(:backup_size).and_return max_size
      allow(object).to receive(:replica_size).and_return max_size
    end

    context "the backup size is larger than the replica size" do
      before do
        allow(object).to receive(:replica_size).and_return 5
      end

      it { is_expected.to eq max_size }
    end
  end

  describe "#current_replica_number" do
    subject { object.current_replica_number }

    it { is_expected.to eq object.backups_and_replicas.count }
  end

  describe "#candidate_volumes" do
    before do
      object_replicas
      other_cell_volume
    end

    subject { object.candidate_volumes.count }

    it { is_expected.to eq 1 }
  end
end
