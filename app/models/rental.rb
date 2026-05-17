class Rental < ApplicationRecord
  include Sanitizable

  belongs_to :quotation
  belongs_to :client
  belongs_to :vehicle, optional: true  # Se asigna luego en Logística
  has_many :dispatch_orders
end
