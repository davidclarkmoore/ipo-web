FactoryGirl.define do
  factory :student do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    gender "female"
    marital_status "Single"
    street_address Faker::Address.street_name
    city Faker::Address.city
    postal_code Faker::Address.zip_code
    country Faker::Address.country
    preferred_phone Faker::PhoneNumber.phone_number
    organization "school"
    birthday Date.today
    heard_about_ipo ["College Group", "YWAM Staff", "Twitter"]
    applied_ipo_before true
  end
end
