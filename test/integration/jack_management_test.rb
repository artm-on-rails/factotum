# frozen_string_literal: true

require "test_helper"

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

  test "Trade master can assign Jack to a mastered Trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    jack = create(:jack)
    sign_in(trade_master)
    assert_changes "jack.trades.count", from: 0, to: 1 do
      put jack_path(jack), params: { jack: {
        occupations_attributes: [
          { trade_id: trade.id }
        ]
      } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "#notice", "Jack was successfully updated."
  end

  test "Trade master can't assign Jack to a not mastered trade" do
    trade = create(:tailor)
    other_trade = create(:reaper)
    trade_master = create(:jack, mastered_trades: [trade])
    jack = create(:jack)
    sign_in(trade_master)
    assert_no_changes "jack.trades.count" do
      put jack_path(jack), params: { jack: {
        occupations_attributes: [
          { trade_id: other_trade.id }
        ]
      } }
    end
    assert_response :forbidden
  end

  test "Trade master can remove Jack from a mastered Trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    jack = create(:jack, trades: [trade])
    sign_in(trade_master)
    assert_changes "jack.trades.count", from: 1, to: 0 do
      put jack_path(jack), params: { jack: {
        occupations_attributes: [
          { id: jack.occupations.first.id, _destroy: "1" }
        ]
      } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "#notice", "Jack was successfully updated."
  end

  test "Trade master cannot remove Jack from a not mastered trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    other_trade = create(:reaper)
    jack = create(:jack, trades: [other_trade])
    sign_in(trade_master)
    assert_no_changes "jack.trades.count" do
      put jack_path(jack), params: { jack: {
        occupations_attributes: [
          { id: jack.occupations.first.id, _destroy: "1" }
        ]
      } }
    end
    assert_response :forbidden
  end

  test "Trade master can change master status of jacks in the mastered trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    jack = create(:jack, trades: [trade])
    occupation = jack.occupations.first
    sign_in(trade_master)
    assert_changes "jack.mastered_trades.count", from: 0, to: 1 do
      put jack_path(jack), params: { jack: {
        occupations_attributes: [
          { id: occupation.id, master: true }
        ]
      } }
    end
    assert_changes "jack.mastered_trades.count", from: 1, to: 0 do
      put jack_path(jack), params: { jack: {
        occupations_attributes: [
          { id: occupation.id, master: false }
        ]
      } }
    end
  end

  test "Trade master cannot change master status of jacks in the not mastered trade" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    other_trade = create(:reaper)
    jack = create(:jack, trades: [other_trade])
    occupation = jack.occupations.first
    sign_in(trade_master)
    assert_no_changes "jack.mastered_trades.count" do
      put jack_path(jack), params: { jack: {
        occupations_attributes: [
          { id: occupation.id, master: true }
        ]
      } }
    end
    assert_response :forbidden
  end

  test "JofAT can edit other jack's details" do
    johannes = create(:jack, :of_all_trades)
    jack = create(:jack, email: "old_email@trade.com")
    sign_in(johannes)
    assert_changes "jack.reload.email",
                   from: "old_email@trade.com",
                   to: "new_email@trades.com" do
      put jack_path(jack), params: { jack: {
        email: "new_email@trades.com"
      } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "#notice", "Jack was successfully updated."
  end

  test "Trade master can't edit other Jack's details" do
    trade = create(:trade)
    trade_master = create(:jack, mastered_trades: [trade])
    jack = create(:jack, trades: [trade])
    sign_in(trade_master)
    assert_no_changes "jack.reload.email" do
      put jack_path(jack), params: { jack: {
        email: "new_email@trades.com"
      } }
    end
  end

  test "Current jack edit redirects to profile edit" do
    jack = create(:jack)
    sign_in(jack)
    get edit_jack_path(jack)
    assert_redirected_to edit_profile_path
  end

  test "Trade master may not remove himself from a mastered trade via jack controller" do
    trade = create(:tailor)
    trade_master = create(:jack, mastered_trades: [trade])
    sign_in(trade_master)
    assert_no_changes "trade_master.trades.count" do
      put jack_path(trade_master), params: { jack: {
        occupations_attributes: [
          { id: trade_master.occupations.first.id, _destroy: "1" }
        ]
      } }
    end
  end
end
