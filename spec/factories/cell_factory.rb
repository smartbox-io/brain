FactoryGirl.define do
  factory :cell do
    uuid              { SecureRandom.uuid }
    sequence(:fqdn)   { |n| "cell#{n}.example.com" }
    status            :healthy
    ip_address        { IPAddr.new(rand(2**32), Socket::AF_INET).to_s }
    public_ip_address { IPAddr.new(rand(2**32), Socket::AF_INET).to_s }
  end
end
