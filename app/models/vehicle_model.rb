class VehicleModel < ApplicationRecord
  include Sanitizable

  belongs_to :vehicle_type
  has_many :vehicles, dependent: :destroy
  has_many :vehicle_model_specs, dependent: :destroy
  has_many :spare_part_compatibilities, dependent: :destroy
end
