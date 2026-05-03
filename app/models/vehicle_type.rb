class VehicleType < ApplicationRecord
  include Sanitizable

  has_many :vehicle_models, dependent: :destroy
end
