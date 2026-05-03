class SupplierProduct < ApplicationRecord
  include Sanitizable

  belongs_to :supplier
  belongs_to :product
end
