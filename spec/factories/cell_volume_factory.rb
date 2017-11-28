FactoryBot.define do
  factory :cell_volume do
    cell_block_device
    total_capacity     { 250.gigabytes }
    available_capacity { 250.gigabytes }
  end
end
