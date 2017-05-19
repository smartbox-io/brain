class UploadToken < ApplicationRecord
  belongs_to :user
  belongs_to :cell
end
