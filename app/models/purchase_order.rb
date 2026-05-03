class PurchaseOrder < ApplicationRecord
  include Sanitizable

  belongs_to :supplier
  belongs_to :requested_by
  has_many :purchase_order_items, dependent: :destroy
end
