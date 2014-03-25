class ProjectMedia < ActiveRecord::Base
  belongs_to :project

  attr_accessible :image, :order
  mount_uploader :image, ProjectImageUploader

  validates :image, :order, presence: true
end