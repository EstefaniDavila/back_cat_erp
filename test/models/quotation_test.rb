require "test_helper"

# class QuotationTest < ActiveSupport::TestCase
#   test "accept_and_generate_order! does not run if already accepted" do
#     quotation = Quotation.new(status: "client_accepted")
#     assert_not quotation.accept_and_generate_order!
#   end

#   test "accept_and_generate_order! changes status and generates order for sales" do
#     # Assuming valid basic creation
#     client = Client.create!(business_name: "Test Company")
#     # We use insert to bypass any model callbacks that might be clearing fields
#     Advisor.insert({
#       id: SecureRandom.uuid,
#       code: "ADV-001", 
#       email: "adv@test.com", 
#       document_number: "99999999", 
#       status: "active",
#       created_at: Time.current,
#       updated_at: Time.current
#     })
#     advisor = Advisor.find_by(code: "ADV-001")
#     quotation = Quotation.create!(client: client, advisor: advisor, status: "pending", quotation_type: "sale", total: 500)
    
#     assert quotation.accept_and_generate_order!
#     assert_equal "client_accepted", quotation.status
#     assert_not_nil quotation.approved_at
    
#     # Check if a SalesOrder was created
#     assert quotation.sales_order.present?
#     assert_equal "pending", quotation.sales_order.status
#   end
# end
