FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "username#{n}" }
    sequence(:email)    { |n| "admin@example#{n}.com" }
    password            "password"
    inactive            false
  end
end
