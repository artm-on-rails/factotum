class Ability
  include CanCan::Ability

  def initialize(jack)
    if jack.of_all_trades?
      can :manage, :all
    end

    if jack.mastered_trades.present?
      can %i[read update], Jack
    end
  end
end
