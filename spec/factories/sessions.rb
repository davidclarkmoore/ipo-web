FactoryGirl.define do
  factory :session, class: Session do
    title Faker::Internet.domain_word
    start_date Date.new(2013, 1).beginning_of_month
    sequence(:end_date) { |n| (Date.new(2013,3).beginning_of_month + n.days).to_s }
    duration "6 - 8 weeks"
  end

  factory :invalid_session, class: Session, parent: :session do
    title nil
  end
end
