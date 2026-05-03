class Supplier < ApplicationRecord
  include Sanitizable

  has_many :supplier_products, dependent: :destroy
  has_many :purchase_orders, dependent: :destroy
end
