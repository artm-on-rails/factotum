# frozen_string_literal: true

# This class defines who can do what to various resources.
# For details see https://github.com/CanCanCommunity/cancancan
class Ability
  include CanCan::Ability

  def initialize(jack)
    simple_jack_rules(jack)
    trade_master_rules(jack)
    jack_of_all_trades_rules(jack)
  end

  def simple_jack_rules(jack)
    # similar to how the default :edit ability is an alias to :update
    alias_action :edit_details, to: :update_details
    # :update_details ability allows updating own fields of Jack
    # :update ability is still necessary to authorize access to the #update
    # action
    can %i[read update update_details], Jack, id: jack.id
  end

  def trade_master_rules(jack)
    return unless jack.master_of_some?

    can %i[read update], Jack
    # block form is used because #of_all_trades? can't be expressed with a hash
    # of attributes
    cannot :update, Jack, &:of_all_trades?
    can %i[read update], Trade, id: jack.mastered_trade_ids
    can :manage, Occupation, trade_id: jack.mastered_trade_ids
    # a trade master can't retire himself from (any) trade
    cannot %i[create update destroy], Occupation, jack_id: jack.id
    # this ability makes newly created abilities in the form be editable
    can %i[edit destroy], Occupation, id: nil
  end

  def jack_of_all_trades_rules(jack)
    return unless jack.of_all_trades?

    # Jack of all trades' may do anything at all to everything. This includes
    # custom abilities such as :update_details
    can :manage, :all
  end
end
