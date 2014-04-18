class Organization < ActiveRecord::Base
  extend Enumerize
  include SFRails::ActiveRecord
  salesforce "Account", [:name]

  enumerize :organization_type, in: %w(Nonprofit Business Individual)

  has_many :field_hosts
  has_many :projects

  attr_accessible :name, :organization_type, :website

  validates_presence_of :name, :organization_type
end
