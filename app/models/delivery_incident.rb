class DeliveryIncident < ApplicationRecord
  include Sanitizable

  belongs_to :delivery_guide
  belongs_to :reported_by
end
