class StockMovement < ApplicationRecord
  include Sanitizable

  belongs_to :spare_part
  belongs_to :performed_by
end
