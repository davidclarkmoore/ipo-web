FactoryGirl.define do
  factory :field_host do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    preferred_phone { Faker::PhoneNumber.short_phone_number }
    phone_type { FieldHost.phone_type.values.sample }
    overall_education "Some College"
    years_associated_with_organization 1
  end
end
