class VehicleModelSpec < ApplicationRecord
  include Sanitizable

  belongs_to :vehicle_model
end
