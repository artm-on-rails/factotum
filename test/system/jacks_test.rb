# frozen_string_literal: true

require "application_system_test_case"

class JacksTest < ApplicationSystemTestCase
  setup do
    @jack = jacks(:one)
  end

  test "visiting the index" do
    visit jacks_url
    assert_selector "h1", text: "Jacks"
  end

  test "creating a Jack" do
    visit jacks_url
    click_on "New Jack"

    click_on "Create Jack"

    assert_text "Jack was successfully created"
    click_on "Back"
  end

  test "updating a Jack" do
    visit jacks_url
    click_on "Edit", match: :first

    click_on "Update Jack"

    assert_text "Jack was successfully updated"
    click_on "Back"
  end

  test "destroying a Jack" do
    visit jacks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Jack was successfully destroyed"
  end
end
