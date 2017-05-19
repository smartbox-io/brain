class DownloadToken < ApplicationRecord
  belongs_to :full_object
  belongs_to :user
  belongs_to :cell
end
