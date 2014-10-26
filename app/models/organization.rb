class Organization < ActiveRecord::Base
  extend Enumerize
  include SFRails::ActiveRecord
  salesforce "Account", [:name, :website], {organization_type: "Type"}

  enumerize :organization_type,
            in: I18n.t("enumerize.organization.organization_type")

  has_many :field_hosts
  has_many :projects

  attr_accessible :name, :organization_type, :website, :description

  validates_presence_of :name, :organization_type
end
