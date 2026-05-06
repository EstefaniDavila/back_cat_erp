class Vehicle < ApplicationRecord
  include Sanitizable

  belongs_to :product, inverse_of: :vehicle
  belongs_to :vehicle_model
  has_many :rentals
  has_many :delivery_guides
  has_many :maintenances, foreign_key: :enterprise_vehicle_id
end
