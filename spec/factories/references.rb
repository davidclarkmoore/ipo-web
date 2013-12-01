# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reference do
    first_name "MyString"
    last_name "MyString"
    email "MyString"
    phone "MyString"
    description "MyString"
  end
end
