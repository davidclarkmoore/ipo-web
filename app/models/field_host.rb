class FieldHost < ActiveRecord::Base
  extend Enumerize
  include SFRails::ActiveRecord
  salesforce "Contact", [:first_name, :last_name, :salutation, :preferred_phone, :phone_type]

  attr_accessible :first_name, :middle_initial, :last_name, :salutation, 
    :email, :role_title, :years_associated_with_organization, :preferred_phone, :phone_type,
    :experience_with_ywam, :heard_about_ipo, :overall_education, :role_title

  serialize :properties, ActiveRecord::Coders::Hstore

  hstore_accessor :properties, :years_associated_with_organization, :experience_with_ywam, :heard_about_ipo,
    :overall_education, :role_title

  enumerize :phone_type, in: %w(Work Household Mobile Other)
  enumerize :salutation, in: %w(Mr. Ms. Dr. Prof. Rev.)

  %w(overall_education).each do |f|
    enumerize f, in: I18n.t("enumerize.field_host.#{f}")
  end

  %w(experience_with_ywam heard_about_ipo).each do |f|
    enumerize f, in: I18n.t("enumerize.field_host.#{f}"), multiple: true

    define_method "#{f}_with_deserialize" do
      value = send("#{f}_without_deserialize")
      value = JSON.parse(send("#{f}_without_deserialize")) if value && value.is_a?(String)
    end
    alias_method_chain f, :deserialize
  end

  belongs_to :organization
  has_many :projects

  validates_presence_of :first_name, :last_name, :email, :preferred_phone, :phone_type, :overall_education
  validates :years_associated_with_organization, :numericality => {:allow_nil => true}

end