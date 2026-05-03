class QuotationItem < ApplicationRecord
  include Sanitizable

  belongs_to :quotation
  belongs_to :product
  belongs_to :customer_asset
end
