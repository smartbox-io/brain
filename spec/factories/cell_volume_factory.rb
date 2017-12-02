FactoryBot.define do
  factory :cell_volume do
    cell_block_device
    sequence(:volume)    { |n| "#{cell_block_device.device}-#{n + 1}" }
    total_capacity       { 250.gigabytes }
    available_capacity   { 250.gigabytes }
    status               :healthy
  end
end
