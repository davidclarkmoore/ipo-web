class Project < ActiveRecord::Base
  include SFRails::ActiveRecord
  salesforce "Project__c", [:name, :description]

  belongs_to :organization
  belongs_to :field_host

  serialize :properties, ActiveRecord::Coders::Hstore

  hstore_accessor :properties, :team_mode, :min_stay_duration, :min_students, :max_students,
    :per_week_cost, :per_week_cost_final, :address, :internet_distance, :location_private, :location_type,
    :location_description, :culture_description, :housing_type, :dining_location, :housing_description,
    :safety_level, :challenges_description, :attire, :guidelines_description, :agree_memo, :agree_to_transport

  attr_accessible :name, :description, :team_mode, :min_stay_duration, :min_students, :max_students,
    :per_week_cost, :per_week_cost_final, :address, :internet_distance, :location_private, :location_type,
    :location_description, :culture_description, :housing_type, :dining_location, :housing_description,
    :safety_level, :challenges_description, :attire, :guidelines_description, :agree_memo, :agree_to_transport,
    :field_host_attributes, :organization_attributes

  accepts_nested_attributes_for :field_host
  accepts_nested_attributes_for :organization

  def self.location_types
    %w(urban suburban rural slum)
  end

  # TODO: Partial validations with wizard steps
  # validates_presence_of :name, :description
  # validates_uniqueness_of :name
end
