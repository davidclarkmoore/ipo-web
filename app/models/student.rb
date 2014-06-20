class Student < ActiveRecord::Base
  extend Enumerize
  include SFRails::ActiveRecord
  salesforce "Contact", 
    [:gender, :created_at, :description, :email, :marital_status, :phone_type,
    :public_contact_information, :published_status, :spoken_languages, :created_at, :updated_at],
    {first_name: 'FirstName', last_name: 'LastName', birthday: 'Birthdate',
    fields_of_study: 'Fields_of_Study__c', preferred_phone: 'Phone', passions: "Passion_Focus__c",
    agree_terms: 'Agree_to_Terms__c', heard_about_ipo: 'Heard_about_IPO__c', 
    street_address: "MailingStreet", state: "MailingState", city: "MailingCity", postal_code: "MailingPostalCode",
    country: "MailingCountry", organization: "School_Church_Student_Organization__c",
    applied_ipo_before: "Applied_IPO_Before__c", graduation_year: "Graduation__c",
    overall_education: "Education__c", experiences: "Experience_with_YWAM__c"
    } 
  
  serialize :properties, ActiveRecord::Coders::Hstore

  hstore_accessor :properties, :overall_education, :graduation_year, :agree_terms

  attr_accessible :first_name, :last_name, :birthday, :gender, :street_address, :city, :state, :postal_code,
    :country, :preferred_phone, :phone_type, :marital_status, :organization, :applied_ipo_before,
    :description, :reference_id, :graduation_year, :agree_terms,
    :login_attributes, :reference_attributes, :person_references_attributes,
    :fields_of_study, :passions, :experiences, :spoken_languages, :heard_about_ipo, :overall_education,
    :profile_picture, :cover_photo, :public_contact_information, :published_status, :biography

  has_many :person_references, as: :referencer, inverse_of: :referencer
  has_many :references, through: :person_references
  has_many :donations
  has_one :login, as: :entity, dependent: :destroy
  has_many :student_applications, dependent: :destroy
  has_many :project_sessions, through: :student_applications
  has_many :projects, through: :project_sessions
  delegate :email, to: :login

  accepts_nested_attributes_for :login
  accepts_nested_attributes_for :person_references

  validates_presence_of :first_name, :last_name, :gender, :marital_status, 
                        :street_address, :state, :city, :postal_code,
                        :country, :preferred_phone, :organization, :birthday, 
                        :heard_about_ipo

  validates_inclusion_of :applied_ipo_before, in: [true, false]
  validates :graduation_year, numericality: {allow_nil: true}

  mount_uploader :profile_picture, LoginImageUploader
  mount_uploader :cover_photo, LoginImageUploader

  %w(overall_education marital_status phone_type).each do |f|
    enumerize f, in: I18n.t("enumerize.student.#{f}")
  end

  %w(fields_of_study passions experiences spoken_languages heard_about_ipo).each do |f|
    enumerize f, in: I18n.t("enumerize.student." + f), multiple: true
  end

  def academic_reference
    @academic_reference ||= references.for_reference_type(:academic_reference)
  end

  def spiritual_reference
    @spiritual_reference ||= references.for_reference_type(:spiritual_reference)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    "#{street_address} #{city} #{postal_code} #{state} #{country}"
  end

  def published_status_to_string
    self.published_status ? "published" : "draft"
  end
  
  def agree_terms; properties["agree_terms"] == "1" ? true : false; end;
end
