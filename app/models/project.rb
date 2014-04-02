class Project < ActiveRecord::Base
  extend Enumerize
  include SFRails::ActiveRecord
  salesforce "Project__c", [:name, :description]

  COMPLETE = "complete"

  belongs_to :organization
  belongs_to :field_host
  has_many :project_media
  has_many :project_sessions
  has_many :sessions, through: :project_sessions
  serialize :properties, ActiveRecord::Coders::Hstore

  hstore_accessor :properties, :min_stay_duration, :min_students, :max_students,
    :per_week_cost, :per_week_cost_final, :required_languages, :student_educational_requirement,
    :internet_distance, :location_type, :transportation_available, :location_description,
    :culture_description, :housing_type, :dining_location, :housing_description, :safety_level,
    :challenges_description, :typical_attire, :guidelines_description, :agree_memo, :agree_to_transport

  attr_accessible :name, :description, :team_mode, :min_stay_duration, :min_students, :max_students,
    :per_week_cost, :per_week_cost_final, :required_languages, :related_student_passions, :related_fields_of_study,
    :student_educational_requirement, :address, :internet_distance, :location_private, :location_type, :transportation_available,
    :location_description, :culture_description, :housing_type, :dining_location, :housing_description,
    :safety_level, :challenges_description, :typical_attire, :guidelines_description, :agree_memo, :agree_to_transport,
    :field_host_attributes, :organization_attributes, :organization_id, :wizard_status, :project_sessions_attributes, :field_host_id

  accepts_nested_attributes_for :field_host
  accepts_nested_attributes_for :organization
  accepts_nested_attributes_for :project_sessions, reject_if: :all_blank, allow_destroy: true

  %w(dining_location internet_distance location_type housing_type safety_level typical_attire student_educational_requirement).each do |f|
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
  validates :min_students, :max_students, :numericality => true, :if => :complete_or_the_project?
  # -- Location
  validates :location_private, inclusion: {in: [true, false]}, :if => :complete_or_location?
  validates :address, :internet_distance,
      :location_description, :culture_description, :presence => true, :if => :complete_or_location?
  # -- Content
  validates :description, :housing_type, :dining_location, :housing_description, :safety_level, :challenges_description,
      :typical_attire, :guidelines_description, :presence => true, :if => :complete_or_content?
  # -- Agreement
  validates :agree_memo, :agree_to_transport, inclusion: { in: [true, 1, 'true', 'T', '1'], message: "You must agree the terms in order to continue" }, :if => :complete_or_agreement?

  scope :recent, order('created_at desc')
  scope :oldest, order('created_at asc')
  scope :by_name, order('name asc')
  scope :completed, where(wizard_status: COMPLETE)

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

  # TODO: Partial validations with wizard steps
  # validates_presence_of :name, :description
  # validates_uniqueness_of :name
end
