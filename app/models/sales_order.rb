class SalesOrder < ApplicationRecord
  include Sanitizable

  belongs_to :quotation
  belongs_to :client
  belongs_to :advisor, optional: true
  has_many :dispatch_orders
end
