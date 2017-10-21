FactoryBot.define do
  factory :sync_token do
    association :source_cell_volume, factory: :cell_volume
    association :target_cell_volume, factory: :cell_volume
    association :object, factory: :full_object
    status      :scheduled
  end
end
