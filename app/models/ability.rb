# This class defines who can do what to various resources.
# For details see https://github.com/CanCanCommunity/cancancan
class Ability
  include CanCan::Ability

  def initialize(jack)
    # Everybody's abilities
    # =====================
    # similar to how the default :edit ability is an alias to :update
    alias_action :edit_details, to: :update_details
    # :update_details ability allows updating own fields of Jack
    # :update ability is still necessary to authorize access to the #update action
    can %i[read update update_details], Jack, id: jack.id
    return unless jack.is_master_of_some?

    # Trade master's abilities
    # ========================
    can %i[read update], Jack
    # block form is used because #of_all_trades? can't be expressed with a hash
    # of attributes
    cannot :update, Jack do |other|
      other.of_all_trades?
    end
    can %i[read update], Trade, id: jack.mastered_trade_ids
    can :manage, Occupation, trade_id: jack.mastered_trade_ids
    # a trade master can't retire himself from (any) trade
    cannot %i[create update destroy], Occupation, jack_id: jack.id
    # this ability makes newly created abilities in the form be editable
    can %i[edit destroy], Occupation, id: nil
    return unless jack.of_all_trades?

    # Jack of all trades' abilities
    # =============================
    # Jack of all trades' may do anything at all to everything. This includes
    # custom abilities such as :update_details
    can :manage, :all
  end
end
