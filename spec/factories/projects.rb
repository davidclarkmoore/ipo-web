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

  factory :project_for_about_you_step, class: Project do
    organization_attributes { FactoryGirl.attributes_for(:organization) }
    field_host_attributes { FactoryGirl.attributes_for(:field_host) } 
    
    trait :invalid do
      organization_attributes { FactoryGirl.attributes_for(:invalid_organization) }
      field_host_attributes { FactoryGirl.attributes_for(:invalid_field_host) }
    end

    factory :invalid_project_for_about_you_step, traits: [:invalid]
  end

  factory :project_for_the_project_step, parent: :project_for_about_you_step do
    name "Test project"
    team_mode true
    min_students 5
    max_students 10
    per_week_cost 50
    per_week_cost_final 1
    required_languages ["","spanish", "english"]
    related_student_passions ["","children_at_risk"]
    related_fields_of_study ["","aviation", "business_and_management"]
    student_educational_requirement "some_college"
  
    trait :invalid do
        name nil
        team_mode nil
    end

    factory :invalid_project_for_the_project_step, traits: [:invalid]
  end

end
