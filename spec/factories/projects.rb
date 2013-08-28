# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name { Faker::Lorem.words(3).join.capitalize }
    description { Faker::Lorem.paragraphs 2 }
  end
end
