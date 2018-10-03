# frozen_string_literal: true

require "test_helper"

class JackManagementTest < ActionDispatch::IntegrationTest
  test "Jack may update own details" do
    jack = create(:jack, email: "old_email@trade.com")
    sign_in(jack)
    assert_changes "jack.reload.email",
                   from: "old_email@trade.com",
                   to: "new_email@trades.com" do
      put profile_path, params: { jack: {
        email: "new_email@trades.com"
      } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "#notice", "Profile was successfully updated."
  end

  test "Jack may not add an occupation to himself" do
    jack = create(:jack)
    trade = create(:tailor)
    sign_in(jack)
    assert_no_changes "jack.trades.count" do
      put profile_path, params: { jack: {
        occupations_attributes: [
          { trade_id: trade.id }
        ]
      } }
    end
  end

  test "Jack may not make himself master of a non-mastered trade" do
    trade = create(:tailor)
    jack = create(:jack, trades: [trade])
    occupation = jack.occupations.first
    sign_in(jack)
    assert_no_changes "jack.mastered_trades.count" do
      put profile_path, params: { jack: {
        occupations_attributes: [
          { id: occupation.id, master: "1" }
        ]
      } }
    end
  end

  test "Jack may not remove himself from a trade" do
    trade = create(:tailor)
    jack = create(:jack, trades: [trade])
    occupation = jack.occupations.first
    sign_in(jack)
    assert_no_changes "jack.trades.count" do
      put profile_path, params: { jack: {
        occupations_attributes: [
          { id: occupation.id, _destroy: "1" }
        ]
      } }
    end
  end

  test "Trade master may not degrade himself from mastership" do
    trade = create(:tailor)
    jack = create(:jack, mastered_trades: [trade])
    occupation = jack.occupations.first
    sign_in(jack)
    assert_no_changes "jack.mastered_trades.count", from: 1 do
      put profile_path, params: { jack: {
        occupations_attributes: [
          { id: occupation.id, master: "0" }
        ]
      } }
    end
  end

  test "Trade master may not remove himself from a mastered trade via profile controller" do
    trade = create(:tailor)
    jack = create(:jack, mastered_trades: [trade])
    sign_in(jack)
    assert_no_changes "jack.trades.count" do
      put profile_path, params: { jack: {
        occupations_attributes: [
          { id: jack.occupations.first.id, _destroy: "1" }
        ]
      } }
    end
  end
end
