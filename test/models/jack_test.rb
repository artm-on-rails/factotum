require 'test_helper'

class JackTest < ActiveSupport::TestCase
  test "Jack is not of all trades by default" do
    jack = create(:jack)
    refute jack.of_all_trades?
  end

  test "Jack of all trades reports that status" do
    johannes = create(:jack, :of_all_trades)
    assert johannes.of_all_trades?
  end

  test "Jack isn't master of his trades by default" do
    tailor = create(:tailor)
    jack = create(:jack, trades: [tailor])
    refute jack.is_master_of?(tailor)
  end

  test "Jack is master of his mastered trades" do
    tailor = create(:tailor)
    jack = create(:jack, mastered_trades: [tailor])
    assert jack.is_master_of?(tailor)
  end

  test "Jack of all trades is master of any trade" do
    tailor = create(:tailor)
    johannes = create(:jack, :of_all_trades)
    assert johannes.is_master_of?(tailor)
  end
end
