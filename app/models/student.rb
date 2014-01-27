class Student < ActiveRecord::Base
  extend Enumerize
  include SFRails::ActiveRecord
  salesforce "Student", [:first_name, :last_name, :birthday, :gender]
  serialize :properties, ActiveRecord::Coders::Hstore

  hstore_accessor :properties, :experiences, :heard_about_ipo, :overall_education, :passions, :spoken_languages,
  :fields_of_study, :graduation_year

  attr_accessible :first_name, :last_name, :birthday, :gender, :street_address, :city, :postal_code,
    :country, :preferred_phone, :phone_type, :marital_status, :organization, :applied_ipo_before,
    :description, :academic_reference_id, :spiritual_reference_id, :experiences, :fields_of_study,
    :heard_about_ipo, :overall_education, :passions, :spoken_languages, :graduation_year, :agree_terms,
    :login_attributes, :student_applications_attributes, :spiritual_reference_attributes, :academic_reference_attributes,
    :wizard_status


  attr_accessor :agree_terms

  # DOES NOT WORK:
  # Is removed once model is saved. Models saved when loaded have valid? false
  # validates_presence_of :agree_terms, if: :complete?

  belongs_to :academic_reference, class_name: "Reference", dependent: :destroy
  belongs_to :spiritual_reference, class_name: "Reference", dependent: :destroy
  has_one :login, as: :entity, dependent: :destroy
  has_many :student_applications, dependent: :destroy
  has_many :projects, through: :student_applications

  accepts_nested_attributes_for :student_applications
  accepts_nested_attributes_for :login
  accepts_nested_attributes_for :spiritual_reference
  accepts_nested_attributes_for :academic_reference

  validates_presence_of :first_name, :last_name, :gender, :marital_status, :street_address, :city, :postal_code,
    :country, :preferred_phone, :organization, :birthday

  validates_inclusion_of :applied_ipo_before, in: [true, false]

  # -- About You
  validates :login, :student_applications, :associated => true, :if => :about_you?
  validates :graduation_year, numericality: {allow_nil: true}

  %w(overall_education marital_status phone_type).each do |f|
    enumerize f, in: I18n.t("enumerize.student.#{f}")
  end

  %w(heard_about_ipo experiences passions spoken_languages fields_of_study).each do |f|
    enumerize f, in: I18n.t("enumerize.student.#{f}"), multiple: true

    define_method "#{f}_with_deserialize" do
      value = send("#{f}_without_deserialize")
      value = JSON.parse(send("#{f}_without_deserialize")) if value && value.is_a?(String)
    end
    alias_method_chain f, :deserialize
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    "#{street_address} #{city} #{postal_code} #{country}"
  end

  def complete?
    wizard_status == 'complete'
  end

  def about_you?
    wizard_status == 'about_you'
  end

  def interests_and_fields_of_study?
    wizard_status == 'interests_and_fields_of_study'
  end

  def important_details?
    wizard_status == 'important_details'
  end
end
