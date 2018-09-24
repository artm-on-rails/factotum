class Ability
  include CanCan::Ability

  def initialize(jack)
    if jack.of_all_trades?
      can :manage, :all
    end
  end
end
