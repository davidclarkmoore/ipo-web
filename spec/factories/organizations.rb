FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    website { Faker::Internet.http_url }
    organization_type { Organization.organization_type.values.sample }
  end
end