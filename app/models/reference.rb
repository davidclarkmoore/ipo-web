class Reference < ActiveRecord::Base
  has_many :students

  include SFRails::ActiveRecord
  salesforce "Contact", 
    [:phone, :created_at, :updated_at, :email],
    {first_name: 'FirstName', last_name: 'LastName'}
  attr_accessible :description, :email, :first_name, :last_name, :phone
  
  validates_presence_of :first_name, :last_name, :email
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :phone, numericality: {allow_nil: true}

  def select_label
    "#{first_name} #{last_name} - #{email}"
  end
end
