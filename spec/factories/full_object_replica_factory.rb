FactoryBot.define do
  factory :full_object_replica do
    association :object, factory: :full_object
    cell_volume
    status :healthy
  end
end
