class PurchaseOrderItem < ApplicationRecord
  include Sanitizable

  belongs_to :purchase_order
  belongs_to :product
end
