FactoryGirl.define do
  factory :project_session do
    title Faker::Internet.domain_word
    start_date Date.today
    end_date { Date.today + 6.months } 
    project_id 1
  end
end
