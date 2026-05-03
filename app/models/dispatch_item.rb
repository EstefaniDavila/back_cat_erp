class DispatchItem < ApplicationRecord
  include Sanitizable

  belongs_to :dispatch_order
  belongs_to :product
end
