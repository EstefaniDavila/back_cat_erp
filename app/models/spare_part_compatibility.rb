class SparePartCompatibility < ApplicationRecord
  include Sanitizable

  belongs_to :spare_part
  belongs_to :vehicle_model
end
