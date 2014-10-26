class Teacher < ActiveRecord::Base

  
  attr_accessible :first_name, :middle_initial, :last_name, :salutation, :role_title, :years_associated_with_organization, 
    :preferred_phone, :phone_type, :heard_about_ipo, :overall_education, 
    :login_attributes, :profile_picture, :created_at, :updated_at, :email

  serialize :properties, ActiveRecord::Coders::Hstore

  hstore_accessor :properties, :years_associated_with_organization, :heard_about_ipo,
    :overall_education


  belongs_to :organization
  has_many :courses


  has_one :login, as: :entity
  accepts_nested_attributes_for :login
  delegate :email, :email=, to: :login
 
  validates_presence_of :first_name, :last_name, :preferred_phone, :phone_type, :overall_education, :years_associated_with_organization
  validates :years_associated_with_organization, :numericality => {:allow_nil => true}

  def full_name
    "#{first_name} #{last_name}"
  end

end