class Ability
  include CanCan::Ability

  def initialize(user)
    customer ||= Customer.new

    #unless customer.email.blank?
      can :manage, :all
    #end
  end
end
