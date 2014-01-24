class StudentApplication < ActiveRecord::Base
  belongs_to :student
  belongs_to :project_session
  before_save :set_to_pending
  
  attr_accessible :student_id, :project_session_id

  validates_uniqueness_of :project_session_id, scope: :student_id
  validates_presence_of :project_session_id

  APPROVED = "approved"
  UNAPPROVED = "unapproved"
  PENDING = "pending"

  def set_to_pending
    self.status = PENDING
    self.application_status = PENDING
  end
end
