class Student < ActiveRecord::Base
  extend Enumerize
  include SFRails::ActiveRecord
  salesforce "Student", [:first_name, :last_name, :birthday, :gender]

  attr_accessible :academic_reference_id, :applied_ipo_before, :birthday,
    :description, :experiences, :fields_of_study, :first_name, :gender, :heard_about_ipo,
    :last_name, :marital_status, :organization, :overall_education, :passions, :spiritual_reference_id,
    :street_address, :city, :postal_code, :country, :preferred_phone, :phone_type,
    :spoken_languages, :graduation_year, :wizard_status, :project_id, :project_session_id,
    :email, :password, :password_confirmation, :agree_terms, :profile_picture, :cover_photo

  attr_accessor :email, :password, :password_confirmation, :agree_terms, :validate_customer

  serialize :properties, ActiveRecord::Coders::Hstore
 
  enumerize :phone_type, in: %w(Work Household Mobile Other)

  hstore_accessor :properties, :experiences, :heard_about_ipo, :overall_education,
    :passions, :spoken_languages, :fields_of_study

  %w(overall_education marital_status).each do |f|
    enumerize f, in: I18n.t("enumerize.field_host.#{f}")
  end

  %w(heard_about_ipo experiences passions spoken_languages fields_of_study).each do |f|
    enumerize f, in: I18n.t("enumerize.field_host.#{f}"), multiple: true

    define_method "#{f}_with_deserialize" do
      value = send("#{f}_without_deserialize")
      value = JSON.parse(send("#{f}_without_deserialize")) if value && value.is_a?(String)
    end
    alias_method_chain f, :deserialize
  end

  has_one :customer, as: :entity
  belongs_to :project
  belongs_to :project_session
  belongs_to :spiritual_reference, class_name: "Reference"
  belongs_to :academic_reference, class_name: "Reference"
  
  validates_presence_of :first_name, :last_name
  validates :graduation_year, numericality: {allow_nil: true}
  validate :valid_customer

  accepts_nested_attributes_for :spiritual_reference
  accepts_nested_attributes_for :academic_reference
  attr_accessible :spiritual_reference_attributes
  attr_accessible :academic_reference_attributes

  mount_uploader :profile_picture, AvatarUploader
  mount_uploader :cover_photo, AvatarUploader

  def complete?
    wizard_status == 'complete'
  end

  def complete_or_about_you?
    wizard_status.include?('about_you') || complete?
  end

  def complete_or_interests_and_fields_of_study?
    wizard_status.include?('interests_and_fields_of_study') || complete?
  end

  def complete_or_important_details?
    wizard_status.include?('important_details') || complete?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    "#{street_address} #{city} #{postal_code} #{country}"
  end

  private

  def must_validate_customer?
    validate_customer
  end

  def valid_customer

    unless self.customer.new_record?
      # set the email if it is an already created customer
      self.email = self.customer.email if self.email.blank?
    end

    #if there was a customer, it should try to update only if they put something in the password
    if !self.password.blank? || !self.password_confirmation.blank?
      unless self.password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,}$/)
        self.errors[:password] << "must contain at least one lowercase letter, one uppercase letter, and one digit, and ensure there are at least 8 characters"
        return false
      end

      unless self.password == self.password_confirmation
        self.errors[:password_confirmation] << "must match"
        return false
      end

      self.customer.password = self.password
      self.customer.password_confirmation = self.password_confirmation
    end

    #or they changed the email
    if self.email != self.customer.email
      unless self.email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        self.errors[:email] << "it is not a valid email"
        return false
      else
        u = Customer.where(email: self.email)

        if u.count > 0 && u.first != self.customer
          self.errors[:email] << "it has already taken"
          return false
        end         
      end

      self.customer.email = self.email
    end

    self.customer.rol = self.class.to_s.underscore unless self.customer.rol
    self.customer.save!
    return true
  end

end
