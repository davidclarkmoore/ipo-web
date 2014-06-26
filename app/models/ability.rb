class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.entity_type == "FieldHost"
      can :edit, Project, field_host_id: user.entity_id
    end
    if user.entity_type == "Student" 
      can :view_profile_page, Student if user.entity.reserved_his_spot?
    end
  end

end
