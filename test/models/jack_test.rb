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
    jack = create(:jack, trades: [tailor])
    refute jack.occupations.first.master
  end
end
