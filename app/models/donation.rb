class Donation < ActiveRecord::Base
  ACTIVE = "Active"
  SUBMITTED = "Submitted"
  CANCELED = "Canceled"

  SPOT_PRICE = 25

  attr_accessible :amount, :customer_id, :subscription_id, :transcation_id, :recurring, :status, :student_id

  belongs_to :student
end
