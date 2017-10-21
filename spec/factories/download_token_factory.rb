FactoryBot.define do
  factory :download_token do
    association :object, factory: :full_object
    user
    cell_volume
    remote_ip "127.0.0.1"
  end
end
