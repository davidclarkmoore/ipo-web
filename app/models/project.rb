class Project < ActiveRecord::Base
  include SFRails::ActiveRecord
  salesforce "Project__c", [:name, :description, :start_date, :end_date]

  belongs_to :organization

  attr_accessible :name, :description, :start_date, :end_date

  validates_presence_of :name, :description
  validates_uniqueness_of :name
end
