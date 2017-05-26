class RefreshToken < ApplicationRecord
  include TokenGeneration

  belongs_to :user
end
