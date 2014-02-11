class ProjectSession < ActiveRecord::Base
  attr_accessible :project_id, :session_id, :application_deadline, :status
  
  validates_presence_of :project_id, :session_id
  before_create :set_status_to_incomplete

  belongs_to :project
  belongs_to :session
  has_many :student_applications

  COMPLETE = 'complete'
  INCOMPLETE = 'incomplete'

  private 

  def set_status_to_incomplete
    self.status = INCOMPLETE
  end
end
