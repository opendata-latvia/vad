class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # === User ===
    if user.super_admin?
      can :invite, User
    end

    # === Declarations ===
    if user.super_admin?
      can :manage, ImportDeclaration
      can :manage, Declaration
    elsif user.persisted?
      can :read, ImportDeclaration
      can :import, ImportDeclaration
      can :read, Declaration
    end

  end
end
