FactoryBot.define do
  factory :cell_block_device do
    cell
    status             :accepted
    total_capacity     { 500.gigabytes }
    available_capacity { 500.gigabytes }
    after(:create) do |cell_block_device|
      create :cell_volume, cell_block_device: cell_block_device
    end
  end
end
