require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "responds to all expected associations" do
    client = Client.new
    assert_respond_to client, :user
    assert_respond_to client, :leads
    assert_respond_to client, :quotations
    assert_respond_to client, :sales_orders
    assert_respond_to client, :maintenances
  end
end
