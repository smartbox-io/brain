FactoryBot.define do
  factory :cell_block_device do
    cell
    sequence(:device)  { |n| "some-device-#{n + 1}" }
    total_capacity     { 500.gigabytes }
    available_capacity { 500.gigabytes }
    status             :healthy
  end
end
