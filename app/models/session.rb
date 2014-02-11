class Session < ActiveRecord::Base
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
    self.application_deadline = Date.today + 60.days
  end

  def start_must_be_before_end_date
    errors.add(:end_date, "must be after start date") unless self.start_date < self.end_date
  end

end
