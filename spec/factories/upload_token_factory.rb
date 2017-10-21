FactoryBot.define do
  factory :upload_token do
    user
    cell_volume
    remote_ip "127.0.0.1"
  end
end
