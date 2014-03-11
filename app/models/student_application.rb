class StudentApplication < ActiveRecord::Base
  COMPLETE = "complete" 
  INCOMPLETE = "incomplete"

  belongs_to :student
  belongs_to :project_session
 
  attr_accessible :student_id, :project_session_id, :wizard_status, :student_attributes, :student, :agree_terms, :status
  accepts_nested_attributes_for :student
  delegate :project, :start_date, :end_date, to: :project_session

  validates_uniqueness_of :project_session_id, scope: :student_id, message: "You already applied for this session"
  validates_presence_of :project_session_id
  validates :agree_terms, inclusion: { in: [true, 1, 'true', 'T', '1'] , message: "You must agree the terms in order to continue" }, :if => :complete_or_important_details?
  before_create :set_incomplete_status

  scope :approved, where(status: COMPLETE)
  scope :unapproved, where(status: INCOMPLETE)
  scope :active, order(:created_at)

  def set_incomplete_status
    self.status = INCOMPLETE
  end

  def complete?
    wizard_status == COMPLETE
  end

  def complete_or_important_details?
    wizard_status.include?('important_details') || complete?
  end

end
