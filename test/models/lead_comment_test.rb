require "test_helper"

class LeadCommentTest < ActiveSupport::TestCase
  test "is invalid without a lead" do
    comment = LeadComment.new(user_id: SecureRandom.uuid, message: "Test comment")
    assert_not comment.valid?, "Comment is valid without a lead"
    assert_not_nil comment.errors[:lead]
  end

  test "is invalid without a user" do
    comment = LeadComment.new(lead_id: SecureRandom.uuid, message: "Test comment")
    assert_not comment.valid?, "Comment is valid without a user"
    assert_not_nil comment.errors[:user]
  end
end
