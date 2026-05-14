require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "status is set to active by default when creating" do
    user = User.new
    user.set_default_data
    assert_equal "active", user.status
  end

  test "jwt_token_payload returns correct format" do
    user = User.new(document_number: "12345")
    payload = user.jwt_token_payload
    assert_not_nil payload[:user]
    assert_equal "12345", payload[:user]["document_number"]
  end
end
