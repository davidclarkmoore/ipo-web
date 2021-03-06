class Session < ActiveRecord::Base
  include SFRails::ActiveRecord

  salesforce "Session__c", [ :start_date, :end_date, :application_deadline, :duration ], 
    { title: "Name" }


  DAYS_TO_APPLICATION_DEADLINE = Settings.sessions.days_to_application_deadline

  attr_accessible :title, :start_date, :end_date, :duration, :application_deadline

  has_many :project_sessions

  validates :title, :start_date, :end_date, :duration, presence: true
  validates_uniqueness_of :start_date, scope: :end_date, message: "There's another session with the same period"
  validate :start_must_be_before_end_date

  before_create :set_application_deadline

  def select_label
    "#{title} (Start: #{start_date}, End: #{end_date})"
  end
 
  def set_application_deadline
    self.application_deadline = self.start_date - DAYS_TO_APPLICATION_DEADLINE
  end

  def start_must_be_before_end_date
    errors.add(:end_date, "must be after start date") unless self.start_date < self.end_date
  end
end
