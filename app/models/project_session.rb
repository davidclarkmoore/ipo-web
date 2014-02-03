class ProjectSession < ActiveRecord::Base
  attr_accessible :end_date, :project_id, :start_date, :title
  
  validates_presence_of :title, :start_date, :end_date, :project_id

  belongs_to :project

  after_save :set_application_deadline

  def select_label
    "#{title} (Start: #{start_date}, End: #{end_date})"
  end

  private 
  def set_application_deadline
    self.application_deadline = Date.today + 60.days
  end
end
