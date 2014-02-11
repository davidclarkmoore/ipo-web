FactoryGirl.define do
  factory :reference do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email Faker::Internet.email
    phone Faker::PhoneNumber.phone_number.gsub(/\D/, '')
  end 
end
