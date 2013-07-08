class Project < ActiveRecord::Base
  attr_accessible :name, :description, :start_date, :end_date

  validates_presence_of :name, :description
  validates_uniqueness_of :name
end
