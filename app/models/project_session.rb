class ProjectSession < ActiveRecord::Base
  attr_accessible :end_date, :project_id, :start_date, :title

  has_many :students
  belongs_to :project

  def select_label
  	"#{title} (Start: #{start_date}, End: #{end_date})"
  end
end
