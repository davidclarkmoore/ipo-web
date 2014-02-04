class ProjectSession < ActiveRecord::Base
  attr_accessible :end_date, :project_id, :start_date, :title, :application_deadline, :status
  
  validates_presence_of :title, :start_date, :end_date, :project_id
  before_create :set_application_deadline_and_status

  belongs_to :project
  has_many :student_applications

  COMPLETE = 'complete'
  INCOMPLETE = 'incomplete'

  def select_label
    "#{title} (Start: #{start_date}, End: #{end_date})"
  end

  private 

  def set_application_deadline_and_status
    self.application_deadline = Date.today + 60.days
    self.status = INCOMPLETE
  end
end
