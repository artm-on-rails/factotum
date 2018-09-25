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
end
