require 'spec_helper'

describe Student do
  it_behaves_like "a model"

  it { should have_one :login }
  it { should belong_to :academic_reference }
  it { should belong_to :spiritual_reference }
  it { should have_many :student_applications }
  it { should have_many(:projects).through(:student_applications) }

  it { should serialize(:properties).as(ActiveRecord::Coders::Hstore) }

  [:first_name, :last_name, :birthday, :gender, :street_address, :city, :postal_code,
  :country, :preferred_phone, :phone_type, :marital_status, :organization, :applied_ipo_before,
  :description, :academic_reference_id, :spiritual_reference_id, :graduation_year, :agree_terms,
  :login_attributes, :spiritual_reference_attributes,  :academic_reference_attributes, 
  :fields_of_study, :passions, :experiences, :spoken_languages, :heard_about_ipo, :overall_education,
  :profile_picture, :cover_photo, :public_contact_information, :published_status, :biography]
  .each do |attr|
    it { should allow_mass_assignment_of(attr)}
  end

  it { should accept_nested_attributes_for :login }
  it { should accept_nested_attributes_for :academic_reference }
  it { should accept_nested_attributes_for :spiritual_reference }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:gender) }
  it { should validate_presence_of(:marital_status) }
  it { should validate_presence_of(:street_address) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:postal_code) }
  it { should validate_presence_of(:preferred_phone) }
  it { should validate_presence_of(:organization) }
  it { should validate_presence_of(:birthday) }
  it { should validate_presence_of(:heard_about_ipo) }
  it { should validate_numericality_of(:graduation_year) }

  %w(overall_education marital_status phone_type).each do |key|
    it { should enumerize(key).in(*I18n.t("enumerize.student.#{key}")) }
  end

  %w(fields_of_study passions experiences spoken_languages heard_about_ipo).each do |key|
    it { should enumerize(key).in(*I18n.t("enumerize.student.#{key}")) }
  end

  let (:student) { Student.new }

  it "#full_name should return first name and last name " do
    student.first_name = 'John'
    student.last_name = 'Doe'
    expect(student.full_name).to eq('John Doe')
  end

  it "#full_address should return street, city, postal_code and country" do
    student.street_address = "street address"
    student.city = "city"
    student.postal_code = "postal code"
    student.country = "country"
    expect(student.full_address).to eq('street address city postal code country')
  end

  it "#published_status_to_string should return 'published' if published_status==true and 'draft' if published_status==false" do
    student.published_status = true
    expect(student.published_status_to_string).to eq('published')
    student.published_status = false
    expect(student.published_status_to_string).to eq('draft')
  end 



end
