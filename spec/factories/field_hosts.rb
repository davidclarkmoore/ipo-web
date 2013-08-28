FactoryGirl.define do
  factory :field_host do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    preferred_phone { Faker::PhoneNumber.short_phone_number }
    phone_type { FieldHost.phone_type.values.sample }
  end
end
