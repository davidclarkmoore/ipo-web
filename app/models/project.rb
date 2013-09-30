class Project < ActiveRecord::Base
  extend Enumerize
  include SFRails::ActiveRecord
  salesforce "Project__c", [:name, :description]

  belongs_to :organization
  belongs_to :field_host
  has_many :project_media

  serialize :properties, ActiveRecord::Coders::Hstore

  hstore_accessor :properties, :team_mode, :min_stay_duration, :min_students, :max_students, 
    :per_week_cost, :per_week_cost_final, :required_languages, :related_student_passions, :related_fields_of_study,
    :student_educational_requirement,
    :address, :internet_distance, :location_private, :location_type, :transportation_available,
    :location_description, :culture_description, :housing_type, :dining_location, :housing_description, 
    :safety_level, :challenges_description, :typical_attire, :guidelines_description, :agree_memo, :agree_to_transport

  attr_accessible :name, :description, :team_mode, :min_stay_duration, :min_students, :max_students, 
    :per_week_cost, :per_week_cost_final, :required_languages, :related_student_passions, :related_fields_of_study,
    :student_educational_requirement,
    :address, :internet_distance, :location_private, :location_type, :transportation_available,
    :location_description, :culture_description, :housing_type, :dining_location, :housing_description, 
    :safety_level, :challenges_description, :typical_attire, :guidelines_description, :agree_memo, :agree_to_transport, 
    :field_host_attributes, :organization_attributes, :organization_id

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

  # TODO: Partial validations with wizard steps
  # validates_presence_of :name, :description
  # validates_uniqueness_of :name
end
