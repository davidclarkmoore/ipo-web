class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.entity_type == "FieldHost"
        can :edit, Project, field_host_id: user.entity_id
    end
  end
end
