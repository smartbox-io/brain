class FullObject < ApplicationRecord
  belongs_to :user

  has_many :full_object_backups, -> { where is_backup: true }, class_name: "FullObjectReplica", dependent: :destroy
  has_many :full_object_replicas, -> { where is_backup: false }, dependent: :destroy
end
