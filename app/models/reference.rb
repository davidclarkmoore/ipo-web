class Reference < ActiveRecord::Base
  attr_accessible :description, :email, :first_name, :last_name, :phone

  has_many :students
end
