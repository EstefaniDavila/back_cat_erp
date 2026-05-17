class QuotationItem < ApplicationRecord
  include Sanitizable

  belongs_to :quotation
  belongs_to :product,        optional: true
  belongs_to :customer_asset, optional: true
end
