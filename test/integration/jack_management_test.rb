require 'test_helper'

class JackManagementTest < ActionDispatch::IntegrationTest
  test "Jack of all trades can create new Jacks" do
    jack = create(:jack, :of_all_trades)
    sign_in(jack)
    get new_jack_path
    assert_response :success
    post jacks_path, params: {
      jack: {
        email: "new_jack@trades.org",
        password: "secret",
        password_confirmation: "secret"
      }
    }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "#notice", "Jack was successfully created."
  end

  test "Normal Jack can't create new Jacks" do
    jack = create(:jack)
    sign_in(jack)
    get new_jack_path
    assert_response :forbidden
    post jacks_path, params: {
      jack: {
        email: "new_jack@trades.org",
        password: "secret",
        password_confirmation: "secret"
      }
    }
    assert_response :forbidden
  end

  test "Normal Jack can't edit other Jack" do
    jack = create(:jack)
    other_jack = create(:jack)
    sign_in(jack)
    get edit_jack_path(other_jack)
    assert_response :forbidden
    put jack_path(other_jack), params: { jack: {} }
    assert_response :forbidden
  end

  test "Trade master can assign Jack to the master's Trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    other_jack = create(:jack)
    sign_in(trade_master)
    get edit_jack_path(other_jack)
    assert_response :success
    put jack_path(other_jack), params: { jack: {
      occupations_attributes: [
        { trade_id: trade.id }
      ]
    }}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "#notice", "Jack was successfully updated."
  end

  test "Trade master can't assign Jack to not mastered trades" do
    trade = create(:tailor)
    other_trade = create(:reaper)
    trade_master = create(:jack, mastered_trades: [trade])
    other_jack = create(:jack)
    sign_in(trade_master)
    put jack_path(other_jack), params: { jack: {
      occupations_attributes: [
        { trade_id: other_trade.id }
      ]
    }}
    assert_response :forbidden
  end

  test "Trade master can remove Jack from the master's Trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    other_jack = create(:jack, trades: [trade])
    occupation_id = other_jack.occupations.first.id
    sign_in(trade_master)
    put jack_path(other_jack), params: { jack: {
      occupations_attributes: [
        { id: occupation_id, trade_id: trade.id, _destroy: "1" }
      ]
    }}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "#notice", "Jack was successfully updated."
  end

  test "Trade master cannot remove Jack from a not mastered trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    other_trade = create(:reaper)
    other_jack = create(:jack, trades: [other_trade])
    occupation_id = other_jack.occupations.first.id
    sign_in(trade_master)
    put jack_path(other_jack), params: { jack: {
      occupations_attributes: [
        { id: occupation_id, trade_id: trade.id, _destroy: "1" }
      ]
    }}
    assert_response :forbidden
  end

  test "Trade master cannot change existing occupation from a not mastered trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    other_trade = create(:reaper)
    other_jack = create(:jack, trades: [other_trade])
    occupation_id = other_jack.occupations.first.id
    sign_in(trade_master)
    put jack_path(other_jack), params: { jack: {
      occupations_attributes: [
        { id: occupation_id, trade_id: trade.id }
      ]
    }}
    assert_response :forbidden
    other_jack.reload
    refute other_jack.trades.include?(other_trade)
  end

  test "Trade master cannot change existing occupation to a not mastered trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    other_trade = create(:reaper)
    other_jack = create(:jack, trades: [trade])
    occupation_id = other_jack.occupations.first.id
    sign_in(trade_master)
    put jack_path(other_jack), params: { jack: {
      occupations_attributes: [
        { id: occupation_id, trade_id: other_trade.id }
      ]
    }}
    other_jack.reload
    refute other_jack.trades.include?(other_trade)
  end
end
