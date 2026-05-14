class DeliveryGuide < ApplicationRecord
  include Sanitizable
  belongs_to :dispatch_order
  belongs_to :driver, class_name: 'LogisticsUser', foreign_key: 'driver_id'  # 👈 Cambia esto
  belongs_to :vehicle
  has_many :delivery_incidents, dependent: :destroy
end
