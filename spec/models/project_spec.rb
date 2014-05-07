require 'spec_helper'

describe Project do

  it { should belong_to :organization }
  it { should belong_to :field_host }
  it { should have_many :project_media }
  it { should have_many :project_sessions }
  it { should have_many :sessions }
  it { should serialize(:properties).as(ActiveRecord::Coders::Hstore) }
  
  [:name, :description, :team_mode, :min_stay_duration, :min_students, :max_students,
    :per_week_cost, :per_week_cost_final, :required_languages, :related_student_passions, :related_fields_of_study,
    :student_educational_requirement, :address, :internet_distance, :location_private, :location_type, :transportation_available,
    :location_description, :culture_description, :housing_type, :dining_location, :housing_description,
    :safety_level, :challenges_description, :typical_attire, :guidelines_description, :agree_memo, :agree_to_transport,
    :field_host_attributes, :organization_attributes, :organization_id, :wizard_status, :project_sessions_attributes, :field_host_id]
  .each do |attr|
    it { should allow_mass_assignment_of(attr)}
  end

  it { should accept_nested_attributes_for(:field_host) }
  it { should accept_nested_attributes_for(:organization) }
  it { should accept_nested_attributes_for(:project_sessions).allow_destroy(true) }

  %w(dining_location internet_distance location_type housing_type safety_level typical_attire student_educational_requirement).each do |key|
    it { should enumerize(key).in(*I18n.t("enumerize.project.#{key}").keys) }
  end

  %w(required_languages transportation_available).each do |key|
    it { should enumerize(key).in(*I18n.t("enumerize.project.#{key}").keys) }
  end
  
  %w(related_fields_of_study related_student_passions).each do |key|
    it { should enumerize(key).in(*I18n.t("enumerize.project.#{key}").keys) }
  end

  let (:project) { Project.new }

  def test_with_status(status)
    project.wizard_status = status
    expect(yield).to be_true
  end

  it "#complete? should return true if status == 'complete'" do
    test_with_status('complete') { project.complete? }
  end

  it "#complete_or_about_you? should return true if status == 'about_you' or status == 'complete'" do
    test_with_status('complete') { project.complete_or_about_you? }
    test_with_status('about_you') { project.complete_or_about_you? }
  end

  it "#complete_or_the_project? should return true if status = 'the_project' or status == 'complete'" do
    test_with_status('complete') { project.complete_or_the_project? }
    test_with_status('the_project') { project.complete_or_the_project? }
  end

  it "#complete_or_location? should return true if status = 'location' or status == 'complete'" do
    test_with_status('complete') { project.complete_or_location? }
    test_with_status('location') { project.complete_or_location? }
  end

  it "#complete_or_content? should return true if status = 'content' or status == 'complete'" do
    test_with_status('complete') { project.complete_or_content? }
    test_with_status('content') { project.complete_or_content? }
  end

  it "#complete_or_agreement? should return true if status = 'agreement' or status == 'complete'" do
    test_with_status('complete') { project.complete_or_agreement? }
    test_with_status('agreement') { project.complete_or_agreement? }
  end

  it "#get_pretty_properties should return a comma separated list for a key in locale" do
    stub(I18n).t { {a: 'a', b: 'b', c: 'c'} }
    expect(project.get_pretty_properties(['a', 'b', 'c'], 'key')).to eq("a, b, c")
  end

end
