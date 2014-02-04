class StudentApplication < ActiveRecord::Base
  belongs_to :student
  belongs_to :project_session
  
  COMPLETE = "complete" 
  INCOMPLETE = "incomplete"

  attr_accessible :student_id, :project_session_id, :wizard_status, :student_attributes, :student, :agree_terms, :status
  accepts_nested_attributes_for :student

  validates_uniqueness_of :project_session_id, scope: :student_id
  validates_presence_of :project_session_id
  before_create :set_incomplete_status


  scope :approved, where(status: COMPLETE)
  scope :unapproved, where(status: INCOMPLETE)


  def set_incomplete_status
    self.status = INCOMPLETE
  end
end
