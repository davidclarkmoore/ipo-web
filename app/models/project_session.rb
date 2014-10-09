class ProjectSession < ActiveRecord::Base
 
  COMPLETE = 'complete'
  INCOMPLETE = 'incomplete'

  attr_accessible :project_id, :session_id
  delegate :title, :start_date, :end_date, :title, :application_deadline, :duration, to: :session
  delegate :status_text, :status, :max_students, :min_students, to: :project

  belongs_to :project
  belongs_to :session
  has_many :student_applications
  
  validates_presence_of :project_id, :session_id
  validates_uniqueness_of :session_id, scope: :project_id, message: "Must be a different session"


  def project_name
    project.name
  end

  def seats_left?
    seats_left > 0
  end
  
  def seats_left
    max_students - reserved_applications.count
  end

  def full?
    seats_left == 0
  end

  def empty?
    approved_applications.count == 0
  end  
  
  def select_label
    "#{self.session.title} - (Start: #{self.session.start_date}, End #{self.session.end_date})"
  end

  def reserved_applications
    student_applications.reserved
  end

  def approved_applications
    student_applications.approved
  end

  def unapproved_applications
    student_applications.unapproved
  end
end