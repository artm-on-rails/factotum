require 'test_helper'

class JackTest < ActiveSupport::TestCase
  test "Jack is not of all trades by default" do
    jack = create(:jack)
    refute jack.of_all_trades?
  end

  test "Factotum is of all trades by default" do
    johannes = create(:factotum)
    assert johannes.of_all_trades?
  end

  test "Jack isn't master of his trades by default" do
    tailor = create(:tailor)
    jack = create(:jack)
    jack.trades = [tailor]
    refute jack.is_master_of?(tailor)
  end

  test "Jack is master of his mastered trades" do
    tailor = create(:tailor)
    jack = create(:jack)
    jack.mastered_trades = [tailor]
    assert jack.is_master_of?(tailor)
  end

  test "Factotum is master of any trade" do
    tailor = create(:tailor)
    johannes = create(:factotum)
    assert johannes.is_master_of?(tailor)
  end
end
