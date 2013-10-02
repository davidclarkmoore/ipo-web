class ProjectMedia < ActiveRecord::Base
  belongs_to :project

  attr_accessible :image
  mount_uploader :image, ProjectImageUploader
end