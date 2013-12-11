
FactoryGirl.define do
  factory :project do
    name { Faker::Lorem.words(3).join.capitalize }
    description { Faker::Lorem.paragraphs 2 }
    team_mode true
    location_private true
  end

  trait :static_name do
    name { Faker::Lorem.words(3).join.capitalize + "_project" }
  end

  trait :individual_mode do
    team_mode false
  end

  trait :complete do
    wizard_status "complete"
    properties {{
      "student_educational_requirement" => "Graduate Degree (MA/MS)",
      "min_students" => rand(1..2), 
      "max_students" => rand(3..10),
      "location" => Faker::Address.city,
      "address" => Faker::Address.street_name,
      "internet_distance" => "On-site (Free)",
      "location_description" => Faker::Lorem.sentence(10),
      "culture_description" => Faker::Lorem.sentence(10),
      "housing_type" => "Dormitory",
      "dining_location" => "Cafeteria",
      "housing_description" => Faker::Lorem.sentence(10),
      "safety_level" => "Never Walk Alone",
      "challenges_description" => Faker::Lorem.sentence(10),
      "typical_attire" => "Very Modest",
      "guidelines_description" => Faker::Lorem.sentence(10),
      "agree_memo" => "true",
      "agree_to_transport" => "true"
    }}
  end
end
