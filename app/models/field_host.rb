class FieldHost < ActiveRecord::Base
  extend Enumerize
  include SFRails::ActiveRecord
  salesforce "Contact", 
            [ :created_at, :updated_at,
              :email, :phone_type, :salutation ],
             { first_name: "FirstName", 
               last_name: "LastName",
               preferred_phone: "Phone",
               middle_initial: "Middle_Name__c",
               role_title: "Title",
               years_associated_with_organization: "Years_Associated_with_Org__c",
               experience_with_ywam: "Experience_with_YWAM__c",
               heard_about_ipo: "Heard_about_IPO__c",
               overall_education: "Education__c"
              }  

  attr_accessible :first_name, :middle_initial, :last_name, :salutation, :role_title, :years_associated_with_organization, 
    :preferred_phone, :phone_type, :experience_with_ywam, :heard_about_ipo, :overall_education, 
    :login_attributes, :profile_picture, :person_references_attributes, :created_at, :updated_at, :email

  serialize :properties, ActiveRecord::Coders::Hstore

  hstore_accessor :properties, :years_associated_with_organization, :experience_with_ywam, :heard_about_ipo,
    :overall_education

  %w(overall_education phone_type salutation).each do |f|
    enumerize f, in: I18n.t("enumerize.field_host.#{f}")
  end

  %w(experience_with_ywam heard_about_ipo).each do |f|
    enumerize f, in: I18n.t("enumerize.field_host.#{f}"), multiple: true
    define_method "#{f}_with_deserialize" do
      value = send("#{f}_without_deserialize")
      value = JSON.parse(send("#{f}_without_deserialize")) if value && value.is_a?(String)
      return value # DO NOT remove this line. Must ensure value 
                   # is always returned regardless if "if" statement runs
    end
    alias_method_chain f, :deserialize
  end

  belongs_to :organization
  has_many :projects
  has_many :project_sessions, through: :projects
  has_many :person_references, as: :referencer
  has_many :references, through: :person_references
  has_one :login, as: :entity

  accepts_nested_attributes_for :person_references, allow_destroy: true
  accepts_nested_attributes_for :login

  delegate :email, :email=, to: :login
 
  validates :person_references, associated: true
  validates_presence_of :first_name, :last_name, :preferred_phone, :phone_type, :overall_education, :years_associated_with_organization
  validates :years_associated_with_organization, :numericality => {:allow_nil => true}


  def full_name
    "#{first_name} #{last_name}"
  end

  def get_pretty_properties(properties, type)
    properties = [] if properties.nil?
    all_properties = I18n.t("enumerize.field_host." + type)
    pretty_properties = []
    properties.each do |property|
      pretty_properties << all_properties[property.to_sym]
    end
    pretty_properties.join(", ")
  end
end