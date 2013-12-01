# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_session do
    title "MyString"
    start_date "2013-12-01"
    end_date "2013-12-01"
    project_id 1
  end
end
