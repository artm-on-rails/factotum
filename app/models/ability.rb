class Ability
  include CanCan::Ability

  def initialize(jack)
    alias_action :edit_details, to: :update_details
    can %i[read update update_details], Jack, id: jack.id
    return unless jack.is_master_of_some?
    can %i[read update], Jack
    cannot :update, Jack do |other|
      other.of_all_trades?
    end
    can %i[read update], Trade, id: jack.mastered_trade_ids
    can :manage, Occupation, trade_id: jack.mastered_trade_ids
    cannot %i[create update destroy], Occupation, jack_id: jack.id
    can %i[edit destroy], Occupation, id: nil
    return unless jack.of_all_trades?
    can :manage, :all
  end
end
