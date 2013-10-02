class Organization < ActiveRecord::Base
  extend Enumerize
  include SFRails::ActiveRecord
  salesforce "Organization", [:name, :organization_type]

  enumerize :organization_type, in: %w(Nonprofit Business Individual)

  has_many :field_hosts
  has_many :projects

  attr_accessible :name, :organization_type, :website

  validates_presence_of :name, :website, :organization_type
end
