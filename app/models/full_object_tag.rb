class FullObjectTag < ApplicationRecord
  belongs_to :object, class_name: "FullObject"
  belongs_to :tag
end
