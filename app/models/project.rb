class Project < ActiveRecord::Base
  extend Enumerize
  include SFRails::ActiveRecord
  salesforce "Project__c", [:name, :description]

  belongs_to :organization
  belongs_to :field_host
  has_many :project_media
  has_many :project_session

  serialize :properties, ActiveRecord::Coders::Hstore

  hstore_accessor :properties, :min_stay_duration, :min_students, :max_students, 
    :per_week_cost, :per_week_cost_final, :required_languages, :related_student_passions, :related_fields_of_study,
    :student_educational_requirement,
    :address, :internet_distance, :location_type, :transportation_available,
    :location_description, :culture_description, :housing_type, :dining_location, :housing_description, 
    :safety_level, :challenges_description, :typical_attire, :guidelines_description, :agree_memo, :agree_to_transport

  attr_accessible :name, :description, :team_mode, :min_stay_duration, :min_students, :max_students, 
    :per_week_cost, :per_week_cost_final, :required_languages, :related_student_passions, :related_fields_of_study,
    :student_educational_requirement,
    :address, :internet_distance, :location_private, :location_type, :transportation_available,
    :location_description, :culture_description, :housing_type, :dining_location, :housing_description, 
    :safety_level, :challenges_description, :typical_attire, :guidelines_description, :agree_memo, :agree_to_transport, 
    :field_host_attributes, :organization_attributes, :organization_id, :wizard_status
  
  #placeholders
  attr_accessor :start_date, :end_date

  accepts_nested_attributes_for :field_host
  accepts_nested_attributes_for :organization

  %w(dining_location internet_distance location_type housing_type safety_level typical_attire student_educational_requirement).each do |f|
    enumerize f, in: I18n.t("enumerize.project.#{f}")
  end

  %w(required_languages related_student_passions related_fields_of_study transportation_available).each do |f|
    enumerize f, in: I18n.t("enumerize.project." + f), multiple: true

    define_method "#{f}_with_deserialize" do
      value = send("#{f}_without_deserialize")
      value = JSON.parse(send("#{f}_without_deserialize")) if value && value.is_a?(String)
    end
    alias_method_chain f, :deserialize
  end

  # -- About You
  validates :field_host, :organization, :associated => true, :if => :complete_or_about_you?
  # -- The Project
  validates :name, :student_educational_requirement, :presence => true, :if => :complete_or_the_project?
  validates :team_mode, inclusion: {in: [true, false]}, :if => :complete_or_the_project?
  validates :min_students, :max_students, :numericality => true, :if => :complete_or_the_project?
  # -- Location
  validates :location_private, :address, :internet_distance,
      :location_description, :culture_description, :presence => true, :if => :complete_or_location?
  # -- Content
  validates :description, :housing_type, :dining_location, :housing_description, :safety_level, :challenges_description,
      :typical_attire, :guidelines_description, :presence => true, :if => :complete_or_content?
  # -- Agreement
  validates :agree_memo, :agree_to_transport, inclusion: { in: [true, 1, 'true', 'T', '1'] }, :if => :complete_or_agreement?


  def complete?
    wizard_status == 'complete'
  end

  def complete_or_about_you?
    wizard_status.include?('about_you') || complete?
  end

  def complete_or_the_project?
    wizard_status.include?('the_project') || complete?
  end

  def complete_or_location?
    wizard_status.include?('location') || complete?
  end

  def complete_or_content?
    wizard_status.include?('content') || complete?
  end

  def complete_or_agreement?
    wizard_status.include?('agreement') || complete?
  end

  # TODO: Partial validations with wizard steps
  # validates_presence_of :name, :description
  # validates_uniqueness_of :name
end
