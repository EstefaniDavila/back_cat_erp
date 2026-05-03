class DeliveryGuide < ApplicationRecord
  include Sanitizable

  belongs_to :dispatch_order
  belongs_to :driver
  belongs_to :vehicle
  has_many :delivery_incidents, dependent: :destroy
end
