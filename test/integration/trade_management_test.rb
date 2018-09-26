require 'test_helper'

class TradeManagementTest < ActionDispatch::IntegrationTest
  test "Jack of all trades can create new Trades" do
    jack_of_all_trades = create(:jack, :of_all_trades)
    sign_in(jack_of_all_trades)
    get new_trade_path
    assert_response :success
    post trades_path, params: {
      trade: {
        name: "Programmer",
      }
    }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "#notice", "Trade was successfully created."
  end

  test "Normal Jack can't create new Trades" do
    jack = create(:jack)
    sign_in(jack)
    get new_trade_path
    assert_response :forbidden
    post trades_path, params: {
      trade: {
        name: "Programmer",
      }
    }
    assert_response :forbidden
  end

  test "Trade master can assign Jack to the master's Trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    jack = create(:jack)
    sign_in(trade_master)
    assert_changes "trade.reload.jacks.count", from: 1, to: 2 do
      put trade_path(trade), params: { trade: {
        occupations_attributes: [
          { jack_id: jack.id }
        ]
      }}
      assert_response :redirect
      follow_redirect!
      assert_response :success
      assert_select "#notice", "Trade was successfully updated."
    end
  end
end
