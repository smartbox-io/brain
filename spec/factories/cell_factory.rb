FactoryBot.define do
  factory :cell do
    uuid              { SecureRandom.uuid }
    sequence(:fqdn)   { |n| "cell#{n}.example.com" }
    status            :healthy
    ip_address        "127.0.0.1"
    public_ip_address { IPAddr.new(rand(2**32), Socket::AF_INET).to_s }
    after(:create) do |cell|
      create :cell_block_device, cell: cell
    end
  end
end
