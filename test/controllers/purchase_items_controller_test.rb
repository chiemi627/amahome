require 'test_helper'

class PurchaseItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get purchase_items_list_url
    assert_response :success
  end

  test "should get add" do
    get purchase_items_add_url
    assert_response :success
  end

end
