class PurchaseItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get list_path
    assert_response :success
  end

  test "Return purchase list by string from request of show_list" do
		post "/agent.json", params: {queryResult: {action: 'show_list'}}
		assert_response :success
		json_response = JSON.parse(response.body)
		assert json_response['fulfillmentText'].length > 0
		assert_match /ビールとおしりふきを買ってきてね/, json_response['fulfillmentText']
	end

	test "When user said to buy beer, the item's done flag is checked" do
		post "/agent.json", params: {queryResult: {action: 'bought', parameters: {goods: 'ビール'}}}
		assert_response :success
		assert_equal(0,Item.where("name='ビール' and done=false").length)
  end

end
