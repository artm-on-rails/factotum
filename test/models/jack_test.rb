# frozen_string_literal: true

require "test_helper"

class JackTest < ActiveSupport::TestCase
  test "Jack is not of all trades by default" do
    jack = create(:jack)
    assert_not jack.of_all_trades?
  end

  test "Jack of all trades reports that status" do
    johannes = create(:jack, :of_all_trades)
    assert johannes.of_all_trades?
  end

  test "Jack isn't master of his trades by default" do
    tailor = create(:tailor)
    jack = create(:jack, trades: [tailor])
    assert_not jack.master_of?(tailor)
  end

  test "Jack is master of his mastered trades" do
    tailor = create(:tailor)
    jack = create(:jack, mastered_trades: [tailor])
    assert jack.master_of?(tailor)
  end

  test "Jack of all trades is master of any trade" do
    tailor = create(:tailor)
    johannes = create(:jack, :of_all_trades)
    assert johannes.master_of?(tailor)
  end

  test "Jack can't be occupied by the same trade twice" do
    trade = create(:trade)
    jack = create(:jack)
    assert_raises ActiveRecord::RecordNotUnique do
      jack.trades = [trade, trade]
    end
  end
end
