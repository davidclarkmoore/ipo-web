
FactoryGirl.define do
  factory :project do
    name { Faker::Lorem.words(3).join.capitalize }
    description { Faker::Lorem.paragraphs 2 }
    address Faker::Address.street_name 
    team_mode true
    location_private true
    properties {{
      "student_educational_requirement" => "Graduate Degree (MA/MS)",
      "min_students" => rand(1..2), 
      "max_students" => rand(3..10),
      "location" => Faker::Address.city,
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

    trait :static_name do
      name { Faker::Lorem.words(3).join.capitalize + "_project" }
    end

    trait :individual_mode do
      team_mode false
    end

    trait :complete do
      wizard_status "complete"
    end

    trait :with_fields_of_study do
      related_fields_of_study ["aviation", "counseling", "social_work"]
    end

    trait :with_student_passions do
      related_student_passions ["poverty", "other"]   
    end

    factory :completed_projects,                traits: [:complete]
    factory :projects_with_static_name,         traits: [:complete, :static_name]
    factory :individual_projects,               traits: [:complete, :individual_mode]
    factory :projects_with_fields_of_study,     traits: [:complete, :with_fields_of_study]
    factory :projects_with_student_passions,    traits: [:complete, :with_student_passions]
    factory :projects_with_fields_and_passions, traits: [:complete, :with_fields_of_study, :with_student_passions]
  end
end
