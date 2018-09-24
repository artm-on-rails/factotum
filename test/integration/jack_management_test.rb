require 'test_helper'

class JackManagementTest < ActionDispatch::IntegrationTest
  setup do
    @jack = create(:jack)
    @jack_of_all_trades = create(:jack, :of_all_trades)
  end

  test "Jack of all trades can create new Jacks" do
    sign_in(@jack_of_all_trades)
    get "/jacks/new"
    assert_response :success
    post "/jacks", params: {
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
    sign_in(@jack)
    get "/jacks/new"
    assert_response :forbidden
    post "/jacks", params: {
      jack: {
        email: "new_jack@trades.org",
        password: "secret",
        password_confirmation: "secret"
      }
    }
    assert_response :forbidden
  end
end
