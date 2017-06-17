class FullObject < ApplicationRecord
  belongs_to :user

  has_many :backups, -> { where is_backup: true }, class_name: "FullObjectReplica"
  has_many :replicas, -> { where is_backup: false }, class_name: "FullObjectReplica"
  has_many :backups_and_replicas, class_name: "FullObjectReplica", dependent: :destroy
  has_many :cell_volumes, through: :backups_and_replicas
  has_many :cells, through: :cell_volumes

  validates :backup_size, numericality: { only_integer: true }
  validates :replica_size, numericality: { only_integer: true }

  before_validation :assign_backup_size, on: :create
  before_validation :assign_replica_size, on: :create

  private

  def assign_backup_size
    # FIXME: make default backup size configurable
    self.backup_size ||= 2
  end

  def assign_replica_size
    # FIXME: make default replica size configurable
    self.replica_size ||= 2
  end
end
