require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jack = create(:jack)
    sign_in(@jack)
  end

  test "show redirects to edit" do
    get profile_path
    assert_redirected_to edit_profile_path
  end

  test "should get edit" do
    get edit_profile_url
    assert_response :success
  end

  test "should update jack" do
    patch profile_path, params: { jack: {
      email: "new_email@trades.com"
    }}
    assert_redirected_to edit_profile_path
  end
end
