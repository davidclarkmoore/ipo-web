# encoding: UTF-8
class Customer < ActiveRecord::Base
  acts_as_authentic do |configuration| 
    configuration.session_class = CustomerSession
    configuration.login_field = :email
  end

  attr_accessible :password, :password_confirmation, :email, :username, :entity_id, :entity_type, :rol

  validates_presence_of :email

  belongs_to :entity, polymorphic: true

  ROLES = %w[master admin project_manager student]

  scope :from_rol, lambda{|rol| where('rol like ?', "%#{rol}%") unless rol.nil?}

  def is_student?
    self.rol == "student"
  end

  def is_project_manager?
    self.rol == "project_manager"
  end

  def is_admin?
    self.rol == "admin"
  end

  def is_master?
    self.rol == "master"
  end

end
