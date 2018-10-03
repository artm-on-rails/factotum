# frozen_string_literal: true

require "test_helper"

class JacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jack = create(:jack, :of_all_trades)
    sign_in(@jack)
  end

  test "should get index" do
    get jacks_url
    assert_response :success
  end

  test "should get new" do
    get new_jack_url
    assert_response :success
  end

  test "should create jack" do
    assert_difference("Jack.count") do
      post jacks_url, params: { jack: { email: "jack@trades.com" } }
    end

    assert_redirected_to edit_jack_url(Jack.last)
    assert_equal Jack.last.email, "jack@trades.com"
  end

  test "should get edit" do
    other_jack = create(:jack)
    get edit_jack_url(other_jack)
    assert_response :success
  end

  test "should update jack" do
    patch jack_url(@jack), params: { jack: { email: "jack@moved.com" } }
    assert_redirected_to edit_jack_url(@jack)
  end

  test "should destroy jack" do
    assert_difference("Jack.count", -1) do
      delete jack_url(@jack)
    end

    assert_redirected_to jacks_url
  end
end
