class StudentApplication < ActiveRecord::Base
  extend Enumerize
  COMPLETE = "complete"
  INCOMPLETE = "incomplete"
  include SFRails::ActiveRecord
  salesforce "Opportunity", [ :start_date, :pay_registration_fee ], 
            { end_date: 'CloseDate', name: 'Name', 
              stage_name: 'StageName', sf_status: 'Status__c' }
    
  SF_STUDENT_APPLICATION_URL = "https://cs18.salesforce.com/services/apexrest/StudentApplication"

  belongs_to :student
  belongs_to :project_session
  
  enumerize :sf_status, in: I18n.t("enumerize.student_application.sf_status")

  accepts_nested_attributes_for :student
  delegate :project, :session, :start_date, :end_date, to: :project_session
  delegate :person_references, :academic_reference, :spiritual_reference, to: :student

  attr_accessible :student_id, :project_session_id, :wizard_status, :student_attributes, 
                  :student, :agree_terms, :status, :sf_status, :pay_registration_fee,
                  :name, :stage_name, :start_date, :end_date

  validates_uniqueness_of :project_session_id, scope: :student_id, message: "You already applied for this session"
  validates_presence_of :project_session_id
  validates :agree_terms, inclusion: { in: [true, 1, 'true', 'T', '1'] , message: "You must agree the terms in order to continue" }, :if => :complete_or_important_details?
  before_create :set_incomplete_status

  scope :approved, where(status: COMPLETE)
  scope :unapproved, where(status: INCOMPLETE)
  scope :active, order(:created_at)

  def project_id
    project.id
  end

  def student_login
    student.login
  end

  def set_incomplete_status
    self.status = INCOMPLETE
  end

  def complete?
    wizard_status == COMPLETE
  end

  def complete_or_important_details?
    wizard_status.include?('important_details') || complete?
  end

  def name
    "#{self.student.full_name} #{self.project_session.title}"
  end

  def stage_name
    :prospecting
  end

  attr_writer :name, :stage_name, :end_date, :start_date
  
  def save_to_sf!
    begin
      c = SFRails.connection
      parameters = Formatter.format_parameters({
          student: self.student, 
          academic_reference: self.student.academic_reference, 
          spiritual_reference: self.student.spiritual_reference, 
          student_application: self, 
          project: self.project_session.project.sf_object_id,
          session: self.session.sf_object_id,
          organization: self.project.organization.sf_object_id })
      response = c.http_post( SF_STUDENT_APPLICATION_URL , parameters )
      parsed = JSON.parse(response.body)
      self.sf_object_id = parsed["Id"]
      self.student.sf_object_id = parsed["Contact__c"]
      self.student.academic_reference.sf_object_id = parsed["Academic_Reference__c"]
      self.student.academic_reference.save
      self.student.spiritual_reference.sf_object_id = parsed["Spiritual_Reference__c"]
      self.student.spiritual_reference.save
      self.save
    rescue Databasedotcom::SalesForceError => e
      Rails.logger.warn "SalesForceError saving StudentApplication #{self.id}: #{e.message}"
      return false
    end
    self
  end
  
end
