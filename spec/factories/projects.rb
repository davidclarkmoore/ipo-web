
FactoryGirl.define do
  factory :project do
    name { Faker::Lorem.words(3).join.capitalize }
    description { Faker::Lorem.paragraphs 2 }
    team_mode true
    location_private true

    trait :static_name do
      name { Faker::Lorem.words(3).join.capitalize + "_project" }
    end

    trait :individual_mode do
      team_mode false
    end

    trait :complete do
      wizard_status "complete"
    end

    trait :with_properties do
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
        "agree_to_transport" => "true",
        "related_fields_of_study" => "[\"Aviation\", \"Counseling\", \"Social Work\"]",
        "related_student_passions" => "[\"Poverty\", \"Other\"]"
      }}
    end

    factory :completed_projects,            traits: [:complete, :with_properties]
    factory :projects_with_static_name,     traits: [:complete, :static_name, :with_properties]
    factory :individual_projects,           traits: [:complete, :individual_mode, :with_properties]
  end
end
