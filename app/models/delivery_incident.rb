# app/models/delivery_incident.rb
class DeliveryIncident < ApplicationRecord
  include Sanitizable

  belongs_to :delivery_guide
  belongs_to :reported_by, class_name: 'User'

  enum incident_type: {
    delayed: 'delayed',
    damaged: 'damaged',
    lost: 'lost',
    wrong_address: 'wrong_address',
    customer_not_found: 'customer_not_found',
    vehicle_breakdown: 'vehicle_breakdown',
    accident: 'accident',
    weather_issues: 'weather_issues',
    other: 'other'
  }

  validates :incident_type, presence: true
  validates :description, presence: true
end