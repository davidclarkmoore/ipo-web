class Ability
  include CanCan::Ability

  def initialize(login)
    login ||= Login.new

    field_host_permissions(login.entity) if login.field_host?
    student_permissions(login.entity) if login.student?
  end

  private

  def student_permissions(student)
    can :view_profile_page, Student if student.reserved_his_spot?
    can :reserve_spot, StudentApplication do |sa| 
      sa.approved?
    end
  end

  def field_host_permissions(field_host)
    can :edit, Project, field_host_id: field_host.id
  end

end
