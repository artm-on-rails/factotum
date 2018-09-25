class Ability
  include CanCan::Ability

  def initialize(jack)
    return unless jack.is_master_of_some?
    can %i[read update], Jack
    can :manage, Occupation, trade_id: jack.mastered_trade_ids
    return unless jack.of_all_trades?
    can :manage, :all
  end
end
