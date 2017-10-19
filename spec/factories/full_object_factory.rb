FactoryGirl.define do
  factory :full_object do
    user
    uuid            { SecureRandom.uuid }
    sequence(:name) { |n| "file-#{n}" }
    size            1024
  end
end
