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
  
    trait :invalid do
        first_name nil
        last_name nil
    end

    factory :invalid_student, traits: [:invalid]
  end

  factory :student_for_interests_and_field_of_study_step, parent: :student do
    passions ["", "Children at Risk", "Drug Abuse"] 
    overall_education "High School Graduate"
    graduation_year "2013"
    spoken_languages ["", "English"]
    fields_of_study ["", "Aviation"]
    experiences ["", "College Outreach"]
    description "about myself"
    spiritual_reference_id ""
    spiritual_reference_attributes { { 
        "first_name"=>"first name", 
        "last_name"=>"last name", 
        "email"=>"mail@server.com", 
        "phone"=>"12341234", 
        "description"=>"I know it from..."} }
    academic_reference_id "" 
    academic_reference_attributes { {
        "first_name"=>"Aldo", 
        "last_name"=>"Ahmed", 
        "email"=>"aldosolis@gmail.com", 
        "phone"=>"12341234", 
        "description"=>"I know her from..."} } 

    trait :invalid do
        passions nil
        overall_education nil
        graduation_year nil
        spoken_languages nil
        fields_of_study nil
        spiritual_reference_attributes { {} }
        academic_reference_attributes { {} }
    end

    factory :invalid_student_for_interests_and_field_of_study_step, traits: [:invalid]
  end

  factory :student_for_important_details_step, parent: :student_for_interests_and_field_of_study_step do
    agree_terms 1

    trait :invalid do
        agree_terms 0
    end

    factory :invalid_student_for_important_details_step, traits: [:invalid]
  end
end
