class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.persisted? && user.admin?
      can :read, :all
      can :manage, JsBin, user_id: user.id
      can [:show, :edit], JsBin

      can :manage, RubyBin, user_id: user.id
      can [:show, :edit], RubyBin

      can :manage, MysqlBin, user_id: user.id
      can [:show, :edit, :schema_png, :schema_html], MysqlBin

    elsif user.persisted? && !user.admin?
      can :manage, JsBin, user_id: user.id
      can :read, JsBin, user_id: user.id

      can :manage, RubyBin, user_id: user.id
      can :read, RubyBin, user_id: user.id

      can :manage, MysqlBin, user_id: user.id
      can :read, MysqlBin, user_id: user.id
      can [:schema_png, :schema_html], MysqlBin, user_id: user.id
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
