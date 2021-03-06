# -*- coding: utf-8 -*-
class Project < ActiveRecord::Base
  extend Enumerize
  include SFRails::ActiveRecord
  include Formatter

  SF_PROJECT_APPLICATION_URL = "https://cs18.salesforce.com/services/apexrest/ProjectApplication"

  DENIED = "denied"
  APPROVED = "approved"
  IN_REVIEW = "in_review"
  COMPLETE = "complete"
  INCOMPLETE = "incomplete"

  salesforce "Project__c",
    [ :status, :agree_memo, :agree_to_transport, :challenges_description,
      :created_at, :culture_description, :description,
      :dining_location, :guidelines_description, :housing_description,
      :housing_type, :internet_distance, :location_city, :location_country,
      :location_description, :location_private, :location_state_or_province,
      :location_street_address, :location_type, :max_students,
      :min_stay_duration, :min_students, :name, :currency,
      :per_week_cost, :per_week_cost_final, :region, :related_fields_of_study, 
      :related_student_passions, :required_languages, :safety_level, 
      :student_educational_requirement, :team_mode, :transportation_available, 
      :typical_attire, :updated_at ]

  searchkick autocomplete: ['name']

  belongs_to :organization
  belongs_to :field_host
  has_many :project_media
  has_many :project_sessions
  has_many :student_applications, through: :project_sessions
  has_many :sessions, through: :project_sessions
  serialize :properties, ActiveRecord::Coders::Hstore

  delegate :references, to: :field_host

  hstore_accessor :properties, :min_stay_duration, :min_students, :max_students,
    :per_week_cost, :per_week_cost_final, :currency, :required_languages, :student_educational_requirement,
    :internet_distance, :location_type, :transportation_available, :location_description,
    :culture_description, :housing_type, :dining_location, :housing_description, :safety_level,
    :challenges_description, :typical_attire, :guidelines_description, :agree_memo, :agree_to_transport

  attr_accessible :name, :description, :team_mode, :min_stay_duration, :min_students, :max_students, :status,
    :per_week_cost, :per_week_cost_final, :currency, :required_languages, :related_student_passions, :related_fields_of_study,
    :student_educational_requirement, :location_street_address, :location_city, :location_state_or_province, :location_country, 
    :internet_distance, :location_private, :location_type, :transportation_available, :location_description, :culture_description, 
    :housing_type, :dining_location, :housing_description, :safety_level, :challenges_description, :typical_attire, 
    :guidelines_description, :agree_memo, :agree_to_transport, :field_host_attributes, :organization_attributes, 
    :region, :organization_id, :wizard_status, :project_sessions_attributes, :field_host_id, :created_at, :updated_at

  accepts_nested_attributes_for :field_host
  accepts_nested_attributes_for :organization
  accepts_nested_attributes_for :project_sessions, reject_if: :all_blank, allow_destroy: true

  enumerize :status, in: %w(incomplete complete in_review approved denied), I18n_scope: "enumerize.project.status"

  %w(dining_location internet_distance location_type housing_type safety_level region
    typical_attire student_educational_requirement).each do |f|
    enumerize f, in: I18n.t("enumerize.project.#{f}")

    # =================
    # TEMPORARY KLUDGE:
    # =================
    # Postgresql array/hstore serialization is interfering with ‘enumerize’.
    # Enumerize creates customer getters for its enumerated properties to return objects of type Enumerize::Value
    # instead of the raw value stored to the database. When object.value is accessed, enumerize returns an object
    # of type Enumerize::Value.
    #
    #
    # When combined with hstore serialization, the serialization "undoes" the getters defined by enumerize, so
    # object.value just returns the raw string saved to the database.
    # Since our getters no longer return an object of type Enumerize::Value, we do not have automatic access
    # to the translated value.
    #
    # The kludge below basically does what enumerize would do for us, and will work in the interim until someone
    # can get enumerize to play well with our hstores.
    #
    define_method "#{f}_text" do
      key = send(f)
      if key
        I18n.t("enumerize.project.#{f}." + key)
      else
        ""
      end
    end
  end

  %w(required_languages transportation_available).each do |f|
    enumerize f, in: I18n.t("enumerize.project." + f), multiple: true

    define_method "#{f}_with_deserialize" do
      value = send("#{f}_without_deserialize")
      value = JSON.parse(send("#{f}_without_deserialize")) if value && value.is_a?(String)
      return value # DO NOT remove this line. Must ensure value 
                   # is always returned regardless if "if" statement runs
    end
    alias_method_chain f, :deserialize
  end

  %w(related_fields_of_study related_student_passions).each do |f|
    enumerize f, in: I18n.t("enumerize.project." + f), multiple: true
  end

  # -- About You
  validates :field_host, :organization, :associated => true, :if => :complete_or_about_you?
 # before_save :relate_fieldhost_to_organization, :if => :complete_or_about_you?
  # -- The Project
  validates :name, :student_educational_requirement, :presence => true, :if => :complete_or_the_project?
  validates :name, uniqueness: true, :if => :complete_or_the_project?
  validates :team_mode, inclusion: {in: [true, false]}, :if => :complete_or_the_project?
  validates :min_students, :max_students, :per_week_cost, :numericality => true, :if => :complete_or_the_project?
  # -- Location
  validates :location_private, inclusion: {in: [true, false]}, :if => :complete_or_location?
  validates :location_street_address, :location_city, :location_state_or_province, :location_country, :region,
   :internet_distance, :location_description, :culture_description, :presence => true, :if => :complete_or_location?
  # -- Content
  validates :description, :housing_type, :dining_location, :housing_description, :safety_level, :challenges_description,
      :typical_attire, :guidelines_description, :presence => true, :if => :complete_or_content?
  # -- Agreement
  validates :agree_memo, :agree_to_transport, inclusion: { in: [true, 1, 'true', 'T', '1'], message: "You must agree the terms in order to continue" }, :if => :complete_or_agreement?


  scope :denied, where(status: DENIED)
  scope :approved, where(status: APPROVED)
  scope :in_review, where(status: IN_REVIEW)
  # unapproved = completed, but hasn't been approved yet.
  scope :unapproved, where("status = ? OR status = ?", COMPLETE, IN_REVIEW) 
  scope :incomplete, where("wizard_status != ?", COMPLETE)
  scope :complete, where(wizard_status: COMPLETE)
  
  scope :recent, order('created_at desc')
  scope :oldest, order('created_at asc')
  scope :by_name, order('name asc')


  # Returns all projects with at least one project session that has available spots.
  # 
  # Counts all approved applications and compare to the total available spots.
  # Returns projects where total available spots > approved applications.

  def self.available_seats
    joins(:project_sessions)
    .joins("
      LEFT OUTER JOIN student_applications 
      ON student_applications.project_session_id = project_sessions.id AND student_applications.status = 'reserved'    
     ")
    .having("(
      CAST(properties -> 'max_students' AS FLOAT) * COUNT(DISTINCT project_sessions.id)) > COUNT(student_applications.id)        
     ")
    .group("projects.id")
  end

  def self.top_ten(array_name)
    items = Project.connection.select_all(
      "select unnest(#{array_name.to_s}) as array_name, 
      count(*) from Projects where status = '#{Project::APPROVED}' 
      group by array_name order by count DESC limit 10")
    items.map{ |item| item["array_name"] }
  end

  def self.top_ten_student_passions
    top_ten(:related_student_passions)
  end

  def self.top_ten_fields_of_study
    top_ten(:related_fields_of_study)
  end

  def seats_left?
    (project_sessions.count * max_students) > reserved_applications.count
  end

  def agree_memo; properties["agree_memo"] == "1" ? true : false; end;
  def agree_to_transport; properties["agree_to_transport"] == "1" ? true : false; end;
  def per_week_cost_final; properties["per_week_cost_final"] == "1" ? true : false; end;

  def max_students
    properties["max_students"].to_i
  end

  def min_students
    properties["min_students"].to_i
  end

  def search_data
    as_json only: [:name, :description]
  end

  def set_to_complete
    return if status == APPROVED
    self.status = COMPLETE
  end

  def editable?
    self.status == COMPLETE || self.status == INCOMPLETE
  end

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

  def relate_fieldhost_to_organization
    self.field_host.organization_id = self.organization_id
  end

  def get_pretty_properties(properties, type)
    properties = [] if properties.nil?

    all_properties = I18n.t("enumerize.project." + type)
    pretty_properties = []
    properties.each do |property|
      pretty_properties << all_properties[property.to_sym]
    end

    pretty_properties.join(", ")
  end

  def full_address
    "#{location_street_address}, #{location_city},
    #{location_state_or_province}, #{location_country}"
  end

  # TODO: Partial validations with wizard steps
  # validates_presence_of :name, :description
  # validates_uniqueness_of :name

  #create/update object in SF
  def save_to_sf!
    # Databasedotcom::SalesForceError must be handled by the caller
    parameters = Formatter.format_parameters({
      project: self,
      organization: self.organization,
      field_host: self.field_host,
      contacts: self.references.to_a,
      sessions: self.sessions.to_a
    })
    response = SFRails.connection.http_post( SF_PROJECT_APPLICATION_URL, parameters )

    # If no error is raised, parse the response and save the SF Ids
    parsed = JSON.parse(response.body)
    self.sf_object_id = parsed["project"]["Id"]
    self.organization.sf_object_id = parsed["project"]["Organization__c"]
    self.field_host.sf_object_id = parsed["project"]["FieldHost__c"]
    parsed["contacts"].each do |contact|
      self.references.find_by_email(contact["Email"]).update_attribute(:sf_object_id, contact["Id"])
    end
    parsed["sessions"].each do |session|
      self.sessions.find_by_start_date(session["Start_Date__c"]).update_attribute(:sf_object_id, session["Id"])
    end
    self.save
  end

  private

  def reserved_applications
    student_applications.reserved
  end

  def approved_applications
    student_applications.approved
  end

end
