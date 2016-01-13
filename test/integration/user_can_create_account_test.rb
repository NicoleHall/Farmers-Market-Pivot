require "test_helper"

class UserCanCreateAccountTest < ActionDispatch::IntegrationTest
  test "user can create account and sees profile" do
    items = create_list(:item, 2)

    visit items_path

    first(:button, "Add to Cart").click
    assert page.has_content?("You added #{items.first.title} to your cart.")

    visit item_path(items.last)

    click_button "Add to Cart"
    assert page.has_content?("You added #{items.last.title} to your cart.")

    find("#shopping_cart").click

    assert_equal cart_path, current_path
    items.each do |item|
      assert page.has_content?(item.title)
      assert page.has_content?(item.description)
      assert page.has_content?(item.price)
      assert page.has_css?("img[src*='#{item.image_path}']")
    end

    visit "/"
    assert page.has_content?("Login")
    click_link_or_button "Create Account"

    assert_equal new_user_path, current_path

    fill_in "First name", with: "Brenna"
    fill_in "Last name", with: "Martenson"
    fill_in "Username", with: "brenna"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_on "Create Account"
    user = User.last
    assert_equal "/dashboard", current_path
    within(".nav-wrapper") do
      assert page.has_content?("Logged in as #{user.first_name}")
    end
    refute page.has_content?("Login")
    assert page.has_content?("Logout")

    find("#shopping_cart").click

    assert_equal cart_path, current_path
    assert page.has_content?(items.first.title)
    assert page.has_content?(items.last.title)
    # items.each do |item|
    #   assert page.has_content?(item.title)
    #   assert page.has_content?(item.description)
    #   assert page.has_content?(item.price)
    #   assert page.has_css?("img[src*='#{item.image_path}']")
    # end
    click_on "Logout"
    refute page.has_content?("Logout")
    assert page.has_content?("Login")
    refute page.has_content?("Logged in as")
  end
end
