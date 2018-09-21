require 'test_helper'

class JacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jack = create(:jack)
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
    assert_difference('Jack.count') do
      post jacks_url, params: { jack: { email: "jack@trades.com" } }
    end

    assert_redirected_to jack_url(Jack.last)
  end

  test "should show jack" do
    get jack_url(@jack)
    assert_response :success
  end

  test "should get edit" do
    get edit_jack_url(@jack)
    assert_response :success
  end

  test "should update jack" do
    patch jack_url(@jack), params: { jack: { email: "jack@moved.com" } }
    assert_redirected_to jack_url(@jack)
  end

  test "should destroy jack" do
    assert_difference('Jack.count', -1) do
      delete jack_url(@jack)
    end

    assert_redirected_to jacks_url
  end
end
