class ProductImage < ApplicationRecord
  include Sanitizable

  belongs_to :product
end
