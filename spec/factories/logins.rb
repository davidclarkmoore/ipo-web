FactoryGirl.define do
  factory :login do
    email Faker::Internet.email
    password "password"
    password_confirmation "password"
  end
end
