class Login < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  validates_presence_of :email
  validates_presence_of :password, :password_confirmation, on: :create
  validates_confirmation_of :password

  # TODO: If Full Name is present on both FieldHost and student, should be field on Login.
  delegate :student_applications, :project_sessions, :full_name, to: :entity, allow_nil: true
  belongs_to :entity, polymorphic: true

  def field_host?
    entity.class.to_s == "FieldHost"
  end

  def student?
    entity.class.to_s == "Student"
  end

end
