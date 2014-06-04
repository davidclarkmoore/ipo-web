class ProjectSession < ActiveRecord::Base
 
  COMPLETE = 'complete'
  INCOMPLETE = 'incomplete'

  attr_accessible :project_id, :session_id, :application_deadline, :status
  delegate :title, :start_date, :end_date, :title, :application_deadline, :duration, to: :session

  belongs_to :project
  belongs_to :session
  has_many :student_applications
  
  validates_presence_of :project_id, :session_id
  validates_uniqueness_of :session_id, scope: :project_id, message: "Must be a different session"
  before_create :set_status_to_incomplete

  def select_label
    "#{self.session.title} - (Start: #{self.session.start_date}, End #{self.session.end_date})"
  end

  private 

  def set_status_to_incomplete
    self.status = INCOMPLETE
  end
end
