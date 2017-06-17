class FullObjectTag < ApplicationRecord
  belongs_to :object, class_name: "FullObject", foreign_key: :full_object_id
  belongs_to :tag
end
