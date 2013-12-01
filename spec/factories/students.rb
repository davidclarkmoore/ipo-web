# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student do
    first_name "MyString"
    last_name "MyString"
    birthday "2013-12-01"
    gender "MyString"
    marital_status "MyString"
    organization "MyString"
    experiences "MyText"
    heard_about_ipo "MyText"
    applied_ipo_before false
    passions "MyText"
    overall_education "MyString"
    year_of_graduation "MyString"
    spoken_languages "MyText"
    fields_of_study "MyText"
    description "MyText"
    address_id 1
    academic_reference_id 1
    spiritual_reference_id 1
  end
end
