require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  def setup
    @item = Item.new(name: "Beer", done: false)
  end

  test "should be valid" do
    assert @item.valid?
  end

  test "name should be present" do
    @item.name = "  "
    assert_not @item.valid?
  end
end
