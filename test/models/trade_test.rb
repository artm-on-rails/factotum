# frozen_string_literal: true

require "test_helper"

class TradeTest < ActiveSupport::TestCase
  test "Jack can't be occupied by the same trade twice" do
    trade = create(:trade)
    jack = create(:jack)
    assert_raises ActiveRecord::RecordNotUnique do
      trade.jacks += [jack, jack]
    end
  end
end
