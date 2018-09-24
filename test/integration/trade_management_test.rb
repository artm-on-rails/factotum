require 'test_helper'

class TradeManagementTest < ActionDispatch::IntegrationTest
  setup do
    @jack = create(:jack)
    @jack_of_all_trades = create(:jack, :of_all_trades)
  end

  test "Jack of all trades can create new Trades" do
    sign_in(@jack_of_all_trades)
    get "/trades/new"
    assert_response :success
    post "/trades", params: {
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
    sign_in(@jack)
    get "/trades/new"
    assert_response :forbidden
    post "/trades", params: {
      trade: {
        name: "Programmer",
      }
    }
    assert_response :forbidden
  end
end
