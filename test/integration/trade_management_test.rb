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

  test "Trade master can't update a not mastered Trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    other_trade = create(:reaper)
    sign_in(trade_master)
    put trade_path(other_trade)
    assert_response :forbidden
  end

  test "Trade master can assign Jack to a mastered Trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    jack = create(:jack)
    sign_in(trade_master)
    assert_changes "trade.jacks.count", from: 1, to: 2 do
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

  test "Trade master can remove Jack from a mastered Trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    jack = create(:jack, trades: [trade])
    sign_in(trade_master)
    assert_changes "trade.jacks.count", from: 2, to: 1 do
      put trade_path(trade), params: { trade: {
        occupations_attributes: [
          { id: jack.occupations.first.id, _destroy: "1" }
        ]
      }}
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "#notice", "Trade was successfully updated."
  end

  test "Trade master can change master status of jacks in the mastered trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    jack = create(:jack, trades: [trade])
    occupation = jack.occupations.first
    sign_in(trade_master)
    assert_changes "jack.mastered_trades.count", from: 0, to: 1 do
      put trade_path(trade), params: { trade: {
        occupations_attributes: [
          { id: occupation.id, master: true }
        ]
      }}
    end
    assert_changes "jack.mastered_trades.count", from: 1, to: 0 do
      put trade_path(trade), params: { trade: {
        occupations_attributes: [
          { id: occupation.id, master: false }
        ]
      }}
    end
  end

  test "JofAT can edit trade's details" do
    johannes = create(:jack, :of_all_trades)
    trade = create(:trade, name: "Original name")
    sign_in(johannes)
    assert_changes "trade.reload.name",
      from: "Original name",
      to: "New and improved name" do
      put trade_path(trade), params: { trade: {
        name: "New and improved name"
      }}
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "#notice", "Trade was successfully updated."
  end

  test "Trade master can't edit trade's details" do
    trade = create(:trade)
    trade_master = create(:jack, mastered_trades: [trade])
    sign_in(trade_master)
    assert_no_changes "trade.reload.name" do
      put trade_path(trade), params: { trade: {
        name: "New and improved name"
      }}
    end
  end

end
