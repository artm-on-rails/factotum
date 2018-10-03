# frozen_string_literal: true

require "test_helper"

class OccupationTest < ActiveSupport::TestCase
  test "Occupation's trade is readonly" do
    occupation = create(:occupation)
    other_trade = create(:trade)
    assert_no_changes "occupation.reload.trade_id" do
      occupation.update(trade: other_trade)
    end
  end

  test "Occupation's jack is readonly" do
    occupation = create(:occupation)
    other_jack = create(:jack)
    assert_no_changes "occupation.reload.jack_id" do
      occupation.update(jack: other_jack)
    end
  end
end
