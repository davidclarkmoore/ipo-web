class FieldHost < ActiveRecord::Base
  extend Enumerize
  include SFRails::ActiveRecord
  salesforce "Contact", [:first_name, :last_name, :salutation, :preferred_phone, :phone_type
]

  attr_accessible :first_name, :last_name, :salutation, :preferred_phone, :phone_type

  serialize :properties, ActiveRecord::Coders::Hstore

  hstore_accessor :properties, :years_associated_with_organization, :experience_with_ywam, :heard_about_ipo,
    :overall_education

  enumerize :phone_type, in: %w(Work Household Mobile Other)
  enumerize :salutation, in: %w(Mr. Ms. Dr. Prof. Rev.)

  belongs_to :organization

  validates_presence_of :first_name, :last_name, :email, :preferred_phone, :phone_type
  validates :years_associated_with_organization, :numericality => {:allow_nil => true}
end
